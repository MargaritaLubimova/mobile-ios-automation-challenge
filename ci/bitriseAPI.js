const request = require('request')
const cp = require('child_process')

class BitriseAPIEnvironment {

    constructor(appSlug) {
        this.host = 'https://api.bitrise.io',
        this.api = '/v0.1/apps'
        this.app = `/${ appSlug }`,
        this.builds = '/builds'
    }

    get buildsUrl() {
        return `${ this.host }${ this.api }${ this.app }${ this.builds }`
    }

}

class BitriseAPI {

    constructor(consoleArguments) {
        this.bitriseArguments = consoleArguments
        this.environment = new BitriseAPIEnvironment(consoleArguments.appSlug.value)
        this.httpMethod = Object.freeze({
            GET: 'GET',
            POST: 'POST'
        })
    }

    async triggerBuild() {
        let body = undefined

        if (this.bitriseArguments.pullRequestID.value) {
            body = JSON.stringify({
                'hook_info': {
                    'type': 'bitrise'
                },
    
                'build_params': {
                    'pull_request_id': `${ this.bitriseArguments.pullRequestID.value }`
                }
            })
        } else if (this.bitriseArguments.commitHash.value) {
            body = JSON.stringify({
                'hook_info': {
                    'type': 'bitrise'
                },
    
                'build_params': {
                    'commit_hash': `${ this.bitriseArguments.commitHash.value }`
                }
            })
        }

        const options = {
            url: `${ this.environment.buildsUrl }`,
            method: this.httpMethod.POST,
            headers: {
                'Authorization': `${ this.bitriseArguments.token.value }`
            },
            body: body
        }

        return new Promise(function(resolve, reject) {
            request(options, function(error, response, body) {
                if (error) {
                    reject(error)
                }
                
                resolve(JSON.parse(body)['build_slug'])
            })
        })
    }

    async getBuildInfo(buildSlug) {
        const options = {
            url: `${ this.environment.buildsUrl }/${ buildSlug }`,
            method: this.httpMethod.GET,
            headers: {
                'Authorization': `${ this.bitriseArguments.token.value }`
            }
        }

        return new Promise(function(resolve, reject) {
            request(options, function(error, _response, body) {
                if (error) {
                    reject(error)
                }
                
                resolve(body)
            })
        })
    }

    async getArtefacts(buildSlug) {
        const options = {
            url: `${ this.environment.buildsUrl }/${ buildSlug }/artifacts`,
            method: this.httpMethod.GET,
            headers: {
                'Authorization': `${ this.bitriseArguments.token.value }`
            }
        }

        return new Promise(function(resolve, reject) {
            request(options, function(error, response, body) {
                if (error) {
                    reject(error)
                }
                
                resolve(body)
            })
        })
    }

    async getArtefact(buildSlug, artefactSlug) {
        const options = {
            url: `${ this.environment.buildsUrl }/${ buildSlug }/artifacts/${ artefactSlug }`,
            method: this.httpMethod.GET,
            headers: {
                'Authorization': `${ this.bitriseArguments.token.value }`
            }
        }

        return new Promise(function(resolve, reject) {
            request(options, function(error, _response, body) {
                if (error) {
                    reject(error)
                }
                
                resolve(body)
            })
        })
    }

    async download(url, path) {
        const filePath = `${ path }`
        const command = `curl -o ${ filePath } '${ url }'`
        
        return new Promise(function(resolve, reject) {
            cp.exec(command, function(error, stdout, stderr) {
                if (error) {
                    reject(error)
                }

                resolve(stdout)
            })
        })
    }

}

module.exports = BitriseAPI

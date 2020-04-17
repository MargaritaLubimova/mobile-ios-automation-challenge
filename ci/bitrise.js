const { setIntervalAsync, clearIntervalAsync } = require('set-interval-async/dynamic')
const ConsoleArguments = require('./consoleArguments.js')
const ExitCode = require('./helper.js')
const BitriseAPI = require('./bitriseAPI.js')

const consoleArguments = new ConsoleArguments()
consoleArguments.process(process.argv)

const bitriseAPI = new BitriseAPI(consoleArguments)

class Bitrise {

    constructor(bitriseAPI) {
        this.bitriseAPI = bitriseAPI
    }

    async start() {
        let buildSlug = undefined
        let artefactSlug = undefined
        let artefactUrl = undefined

        try {
            buildSlug = await this.bitriseAPI.triggerBuild()
        } catch (error) {
            console.log("Triggering build failed: " + error.message)
            process.exit(ExitCode.buildFailed)
        }

        try {
            await this.getBuildStatus(buildSlug)
        } catch (error) {
            console.log("Triggering build failed: " + error.message)
            process.exit(ExitCode.buildFailed)
        }

        try {
            const artefacts = await bitriseAPI.getArtefacts(buildSlug)
            const filteredArtefacts = JSON.parse(artefacts)['data'].filter(function(value) {
                return value['title'].toString().endsWith('.zip')
            })
            
            if (filteredArtefacts[0]) {
                artefactSlug = filteredArtefacts[0]['slug']
            } else {
                throw 'Searching zip file was failed'
            }
        } catch (error) {
            console.log("Getting build artefacts failed: " + error.message)
            process.exit(ExitCode.buildFailed)
        }            

        try {
            const artefact = await bitriseAPI.getArtefact(buildSlug, artefactSlug)
            artefactUrl = JSON.parse(artefact)['data']['expiring_download_url']
        } catch (error) {
            console.log("Getting build artefact failed: " + error.message)
            process.exit(ExitCode.buildFailed)
        }

        try {
            const artefactPath = './result.zip'
            await bitriseAPI.download(artefactUrl, artefactPath)
            
            console.log(`File ${ artefactPath } downloaded`)
            console.log('Build finished')
            process.exit(ExitCode.success)
        } catch (error) {
            console.log("Downloading artefact failed: " + error.message)
            process.exit(ExitCode.buildFailed)
        }
    }

    async getBuildStatus(buildSlug) {
        const _bitriseAPI = this.bitriseAPI
        const _buildSlug = buildSlug

        return new Promise(function(resolve, reject) {
            async function _getBuildStatus() {
                try {
                    const info = await _bitriseAPI.getBuildInfo(_buildSlug)
                    const finished = JSON.parse(info)['data']['finished_at']
                    const status = JSON.parse(info)['data']['status']

                    if (finished) {
                        if (status == 1) {
                            clearIntervalAsync(timer)
                            resolve(info)
                        } else {
                            reject()
                        }
                    } else {
                        console.log('Building')
                    }
                } catch (error) {
                    console.log("Getting build status failed: " + error.message)
                    process.exit(ExitCode.buildFailed)
                }
            }

            const timer = setIntervalAsync(_getBuildStatus, 30 * 1000)
        
            setTimeout(() => {
                clearIntervalAsync(timer)
                console.log('Build failed')
                process.exit(ExitCode.buildFailed)
            }, _bitriseAPI.bitriseArguments.buildTimeout.value * 60 * 1000)
        })
    }

}

const bitrise = new Bitrise(bitriseAPI)
bitrise.start()
    
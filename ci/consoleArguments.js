const ExitCode = require('./helper.js')

const consoleArguments = Object.freeze({
    commitHash: { name: '-c=', description: 'commit hash', value: undefined },
    pullRequestID: { name: '-p=', description: 'pull request id', value: undefined },
    token: { name: '-t=', description: 'token', value: undefined },
    appSlug: { name: '-a=', description: 'app slug', value: undefined},
    buildTimeout: { name: '-bt=', description: 'build timeout', value: 10 },
    help: { name: '-h=', description: 'help' }
})

class ConsoleArguments {

    constructor() {
        this.commitHash = consoleArguments.commitHash
        this.pullRequestID = consoleArguments.pullRequestID
        this.token = consoleArguments.token
        this.appSlug = consoleArguments.appSlug
        this.buildTimeout = consoleArguments.buildTimeout
        this.help = consoleArguments.help
    }

    process(consoleArguments) {
        consoleArguments.forEach(element => {

            // commit hash
            
            if (element.includes(this.commitHash.name)) {
                this.commitHash.value = element.split('=')[1]
            }
        
            // pull request
        
            if (element.includes(this.pullRequestID.name)) {
                this.pullRequestID.value = element.split('=')[1]
            }
        
            // token
        
            if (element.includes(this.token.name)) {
                this.token.value = element.split('=')[1]
            }
        
            // app slug 
        
            if (element.includes(this.appSlug.name)) {
                this.appSlug.value = element.split('=')[1]
            }
        
            // build timeout
        
            if (element.includes(this.buildTimeout.name)) {
                this.buildTimeout.value = element.split('=')[1]
            }
        
            // help
        
            if (element.includes(this.help.name)) {
                this.panic(this.help)
                process.exit(ExitCode.invalidInput)
            }
        
        })

        this.validate()
    }

    validate() {
        let shouldPanic = false

        Object.values(consoleArguments).forEach(element => {
            if (element.value != undefined) {
                return
            }

            if ((element.description == this.commitHash.description && this.pullRequestID.value == undefined) 
            || (element.description == this.pullRequestID.description && this.commitHash.value == undefined)) {

                this.panic(element)
                shouldPanic = true
            } else if (element.description != this.commitHash.description 
                && element.description != this.pullRequestID.description 
                && element.description != this.help.description) {
                    
                this.panic(element)
                shouldPanic = true
            }
        })

        if (shouldPanic) {
            process.exit(ExitCode.invalidInput)
        }
    }

    panic(consoleArgument) {
        if (consoleArgument == this.help) {
            console.log('How to use:')

            Object.values(consoleArguments).forEach(element => {
                console.log(`${ element.name }${ element.description }`)
            })
        } else {
            console.log(`Please, add ${ consoleArgument.description } argument, eg: ${ consoleArgument.name }${ consoleArgument.description }`)
        }
    }

}

module.exports = ConsoleArguments

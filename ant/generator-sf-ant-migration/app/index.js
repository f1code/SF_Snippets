var generators = require('yeoman-generator');

module.exports = generators.Base.extend({
    answers: {},

    prompting: function() {
        return this.prompt([{
            type: 'input',
            name: 'username',
            message: 'SF Username'
        }, {
            type: 'input',
            name: 'password',
            message: 'SF Password'
        }, {
            type: 'input',
            name: 'token',
            message: 'Security Token (if needed)'
        }, {
            type: 'confirm',
            name: 'production',
            message: 'Run in Production',
            'default': false
        }]).then(function(answers) {
            this.answers = answers
        }.bind(this));
    },
    writing: {
        copyJar: function() {
            this.fs.copy(this.templatePath('ant-salesforce.jar'),
                         this.destinationPath('ant-salesforce.jar'));
        },
        copyBuild: function() {
            this.fs.copyTpl(this.templatePath('build.xml'),
                            this.destinationPath('build.xml'), this.answers);
            this.fs.copyTpl(this.templatePath('build.properties'),
                            this.destinationPath('build.properties'), this.answers);
        }
    }
});

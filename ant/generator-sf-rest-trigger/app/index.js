var generators = require('yeoman-generator'),
  fs = require('fs');

module.exports = generators.Base.extend({
  answers: {},

  prompting: function() {
    return this.prompt([
      {
        type: 'input',
        name: 'name',
        message: 'Project Name (will be used as prefix for classes)'
      },
      {
        type: 'input',
        name: 'entity',
        message: 'Entity to Trigger on'
      },
      {
        type: 'input',
        name: 'externalIdProperty',
        message:
          "External Id Property (if applicable, where do you want to store the remote system's id)"
      },
      {
        type: 'input',
        name: 'testFactory',
        message: 'Test object factory (e.g TestUtils.createAccount)'
      }
    ]).then(
      function(answers) {
        this.answers = {
          ...answers,
          entityName: answers.entity.replace(/__c/, '')
        };
      }.bind(this)
    );
  },

  writing: {
    // need to grab all the class files, rename them, perform substitution inside
    copyAll: function() {
      var allFiles = [];
      this._copyTemplates('apexCode/');
    }
  },

  _transformFileName: function(src) {
    return src
      .replace(/Rest/, this.answers.name)
      .replace(/Entity/, this.answers.entity.replace(/__c$/, ''));
  },

  _copyTemplates: function(dir) {
    var files = fs.readdirSync(this.sourceRoot() + '/' + dir);
    files.forEach(
      function(src) {
        var stat = fs.statSync(this.sourceRoot() + '/' + dir + src);
        if (stat.isDirectory()) {
          this._copyTemplates(dir + src + '/');
        } else if (stat.isFile()) {
          var dst = this._transformFileName(src);
          console.log('destination ' + dst);
          this.fs.copyTpl(
            this.templatePath(dir + src),
            this.destinationPath(dir + dst),
            this.answers
          );
        }
      }.bind(this)
    );
  }
});

# Angulib - AngularCLI module to library packager

Bash script for package [AngularCLI](https://cli.angular.io/) module into Angular libray for npm or local development.

This script is based on the amazing libray [ng-packagr](https://github.com/dherges/ng-packagr) of [David Herges](https://github.com/dherges) 
and on the wonderful [article](https://medium.com/@ngl817/building-an-angular-4-component-library-with-the-angular-cli-and-ng-packagr-53b2ade0701e) of [Nikolas LeBlanc](https://medium.com/@ngl817).

It's just a convertion of the article into bash command.

Tested on angularCLI 1.5.


## Install 

Install [AngularCLI](https://cli.angular.io/).

Create new project or use a current AngularCLI project.

[ WARNING :  the name of your project will be the name of the final library !! ]

Add the angulib.sh script in the root folder of your AngularCLI Project, near the src folder.


## Use

Before use this script, you should read the Nikolas LeBlanc's [article](https://medium.com/@ngl817/building-an-angular-4-component-library-with-the-angular-cli-and-ng-packagr-53b2ade0701e).

Inside your AngularCLI project, create a new module and connect it to main app module .

Add code in this new module for build your library.

Once your done, just enter in the terminal of your IDE or computer, :

```bash
$ bash angulib.sh
```

Follow screen instructions.


## Description

- 1 Setup project

  Check for ng-packagr installation, and install it if needed.
  Create the ng-packagr.json file.
  Modify the package.json file : add a packagr script for futur build.
 
- 2 Define path and file name of the module

  Here your define path and file name of your module.

  For example, if you have a home.module.ts file in a home folder at the root of your app, the path will be :
  src/app/home/home.module

  [Don't specify .ts extention]

  The script create the public_api.ts file.

- 3 Package files

  Try to package file with ng-packagr and put it in a dist folder.
  Compress files in a .tgz file inside the dist folder.

- 4 Complete !

  Now you have a dist folder at the root of your project.
  It contain : 
    - all the files you need for a npm publication ([npm-publish](https://docs.npmjs.com/cli/publish))
    - a .tgz file for local development (see next section)


## Use tgz file 

If you don't want to publish to npm, but you want to share your library with other project, use the .tgz file.

Add the .tgz at the root of your second project.

Open terminal and run : 
```bash
npm install yourLibrary.tgz
```
Now in the nodes modules folder you can see your library folder.

Import and use your module library in your second project.


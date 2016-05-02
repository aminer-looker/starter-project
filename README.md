This is a template for a generic Dataflux client/server project.  If you would like to create a project starting from this template, do the following:

    git clone git@github.com:aminer-looker/starter-project <your project name>
    cd <your project name>
    rm -rf .git
    git init
    git add -A
    git commit -m "initial commit"

Now you'll have a brand new project which has its own separate repository, and is ready to be connected to a new GitHub repo (if you so choose).  In that case, go ahead and create your repository, and then run the following command:

    git remote add origin git@github.com:<your GitHub username>/<your new repo name>.git
    git push -u origin master

Now, your new repository will contain the contents of your started project, and you're ready to start working!  Just run the following command to install all the build tools you need:

    ./scripts/init

### Learning Dataflux

If you're new to Dataflux, this starter project also has a lot of helpful documentation and best practices
written into the code.  As you read the code, play around with the app and watch the console log to see how
it behaves.

### How to use things...

| Command              | Result                                            |
|----------------------|---------------------------------------------------|
| `grunt clean`        | remove all build files and artifacts              |
| `grunt build`        | rebuild the project from scratch                  |
| `grunt start`        | start a local server on port 8080                 |
| `grunt test`         | execute all unit tests                            |
| `grunt watch`        | watch files for changes and automatically rebuild |

Once the server is running, you should be able to connect to `http://localhost:8080`

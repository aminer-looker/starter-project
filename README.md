This is a template for a generic Node/Angular client/server project.  If you would like to create a project starting from this template, do the following:

    git clone git@github.com:aminer-looker/starter-project <your project name>
    cd <your project name>
    rm -rf .git
    git init
    git add -A
    git commit -m "initial commit"

Now you'll have a brand new project which has its own separate repository, and is ready to be connected to a new GitHub repo (if you so choose).  In that case, go ahead and create your repository, and then run the following command:

    git remote add origin git@github.com:<your GitHub username>/<your new repo name>.git
    git push -u origin master

Now, your new repository will contain the contents of your started project, and you're ready to start working!

### How to use things...

|                      |               |
|----------------------|---------------|
| Building the project | `grunt build` |
| Running the server   | `grunt start` |
| Watching changes     | `grunt watch` |
| Cleaning the project | `grunt clean` |

Once the server is running, you should be able to connect to `http://localhost:8080`

### Where to add things...

|   |   |
|---|---|
| HTML Pages | Create a new Jade file in `/src/jade/pages/`. It will be available at the same URL path when the server is running. |
| SCSS for Pages | Create a new file in `/src/scss/pages`. Be sure to use an `id` attribute to restrict the scope to just that page. Update `/src/scss/pages/main.scss` to import your new file.  It is highly encouraged to make this file name match the page's file name. |
| Angular Modules | Create a few file for each module in `/coffee/client/modules/` and then update `/coffee/client/client.coffee` to tie it into Angular.
| Templates | Create a new file under `/src/jade/templates`. It will be available as an attribute of the templates file which gets generated in `/src/coffee/client`.  Just `require` the templates file, and your template will be available as a property with the same name as the file (without the extension). |
| SCSS for Templates | Create a new file in `/src/scss/templates`. Be sure to use a top-level selector to restrict the scope to just that page. Update `/src/scss/templates/main.scss` to import your new file. It is highly encouraged to make this file name match the template's file name. |
| Generic SCSS | The various files directly inside `/src/scss` can be used to add global declarations for fonts, color, tags, classes, etc. |
| Server-Side Routes | Update the `/src/coffee/server/routes.coffee` file to include whatever routes you like. Anything not specified is assumed to be a static file. |

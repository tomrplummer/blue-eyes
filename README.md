# blue-eyes

This is a "toy" project/file generater for projects using Sinatra, Sequel, Haml and Tailwind.css.

It doesn't necessarily use sane defaults, isn't flexible and only works "fully" on macos.  Again, a toy project.

~~Sequel~~, ~~sqlite3~~ and ~~foreman (if using bin/dev)~~ are expected to be installed globally.  Maybe more.

## Examples

#### Create a new and run a new project
```
blue-eyes new my_project
...
cd my_project
blue-eyes migrate
bin/dev
```

#### Add a new resource
Generates model, controller, view (index only...and blank) and migration scripts.
```
blue-eyes g scaffold Posts --fields String:title String:content --as blogs
```
Because of --as, the url will be /blogs

Path helpers are generated as well.
```ruby
# function names use the resource name
# generated paths will use --as if there is one
# based on the above scaffold, the url would be
# http://localhost:9292/blogs
get_posts_path()
get_post_path(post)
new_post_path()
post_post_path() # this should probably be create_post_path...to do
edit_post_path(post)
update_post_path(post)
destory_post_path(post)

```

Other than scaffold, you can do model, controller or api (model and controller).  Anything with model will include migration scripts. Api should do way more than it does at the moment.  Right now it isn't helpful for anything other than generating some files with controller actions that don't make since. TODO.

Speaking of migrations, there are a few basic commands to generate those too.
```
blue-eyes g migration drop posts
blue-eyes g migration alter posts --add String:role String:middle_name
blue-eyes g migration alter posts --drop middle_name
```
As seen with the new project snippet, migrate will run all migration scripts.
```
blue-eyes migrate
```

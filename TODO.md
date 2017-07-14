Remaining items to test / implement:

* Error handling
* 404, 500 pages
* Write tests
* Make gem with binary
* Generators
* Scripts
* Regex routes?
* Yaml for sitemap?
* Nicer default page
* Example controllers
* Include user resource
* Dot syntax for params, flash, session, cookies, errors?

cookie.key = {val => options}
cookie.key = [val, options]
session.key = val
params.key = val

Must return nil if not found and be assignable (unlike hash_dot)
Must be able to handle << without pre-initialization

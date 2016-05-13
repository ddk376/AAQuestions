# AA Questions
Application that helps handle questions from students by overlaying Ruby code to map the data from
the database into Ruby objects. Uses Heredocs to query in ruby.
- Uses Singleton Module to create a single instance of a database connection

## How to Use
- in the command line run `./import_db.sh`

## Bonus Implementations
- [ ] ModelBase class that abstracts the common functionalities.
- [ ] where accepts an options hash as an argument and searches the database for records
      which match the criteria
      `Question.where({author_id: 2})`
- [ ] overwrites `method_missing` to implement a dyname `find_by`
- [ ] where also accepts a string fragment which will be used to directly define WHERE statement in SQL query

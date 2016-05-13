# AA Questions
Application that helps handle questions from students by overlaying Ruby code to map the data from
the database into Ruby objects. Uses Heredocs to query in ruby.
- Uses Singleton Module to create a single instance of a database connection
- Demonstrates complex queries which will also lead to further abstraction of the ORM in the ActiveRecordLite project []
- can update and save records through the AA Questions API to query into the database
- Optimizes N+1 queries for   `User#average_karma` which computes the avg number of likes for a `User`'s questions

## How to Use
- in the command line run `./import_db.sh` to setup the database


## Bonus Implementations
- [ ] ModelBase class that abstracts the common functionalities.
- [ ] where accepts an options hash as an argument and searches the database for records
      which match the criteria
      `Question.where({author_id: 2})`
- [ ] overwrites `method_missing` to implement a dynamic `find_by`
- [ ] where also accepts a string fragment which will be used to directly define WHERE statement in SQL query

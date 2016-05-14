# AA Questions
Application that helps handle questions from students by overlaying Ruby code to map the data from
the database into Ruby objects. Uses Heredocs to query in ruby.
- Uses Singleton Module to create a single instance of a database connection
- Demonstrates complex queries which will also lead to further abstraction of the ORM in the ActiveRecordLite project [ActiveRecordLite](https://github.com/ddk376/ActiveRecordLite)
- can update and save records through the AA Questions API to query into the database
- Optimizes N+1 queries for   `User#average_karma` which computes the avg number of likes for a `User`'s questions
- Uses meta-programming `Object#instance_variables` and `::send` to abstract common functionalities

## How to Use
- in the command line run `cat import_db.sql | sqlite3 questions.db` to setup the database


## Bonus Implementations
- [x] ModelBase class that abstracts the common functionalities
- [x] `::where` accepts an options hash as an argument and searches the database for records which match the criteria
      `Question.where({author_id: 2})`
- [x] overwrites `method_missing` to implement a dynamic `find_by`
- [x] where also accepts a string fragment which will be used to directly define WHERE statement in SQL query

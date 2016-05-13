require_relative 'questions_database'
class TableModel
  TABLES_HASH = {
    :Question => "questions",
    :User => "users",
    :Reply => "replies",
    :QuestionLike => "question_likes",
    :QuestionFollow => "question_follows"
    }
  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{TABLES_HASH[self.to_s.to_sym]}
      WHERE
        #{TABLES_HASH[self.to_s.to_sym]}.id = (?)
    SQL

    results.map { |result| self.new(result) }
  end

  def method_missing

  end

  def save
    if id.nil?
      create
    else
    end
  end

  def create
    raise "You already exist!" unless id.nil?
    columns = self.instance_variables.map do |var|
      length = var.length
      var.to_s[1,length -1]
    end

    columns = columns.select { |col| col != "id" }

    values = []

    columns_proc = columns.map { |col| Proc.new {self".#{col}"} }

    columns_proc.each { |prc| values << prc.call }

    QuestionsDatabase.instance.execute(<<-SQL)
      INSERT INTO
        #{TABLES_HASH[self.class.to_s.to_sym]}(#{columns.join(",")})
      VALUES
        (#{values.join(",")})
    SQL
  end
end

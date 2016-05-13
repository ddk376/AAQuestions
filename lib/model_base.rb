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

  def method_missing(method_name, *args)
    method_name = method_name.to_s
    if method_name.start_with?("find_by_")
      attributes_string = method_name[("find_by_".length)..-1]
      attributes_names = attributes_string.split("_and_")

      unless attribute_names.length == args.length
        raise "unexpected # of arguments"
      end

      search_conditions = {}
      attribute_names.length.times do |i|
        search_conditions[attribute_name[i]] = args[i]
      end
      ## self.search search_conditions
    else
      super
    end
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

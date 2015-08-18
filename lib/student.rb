# require 'pry'

class Student

  attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography

  def self.create_table
      sql = <<-SQL
        CREATE TABLE students (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          tagline TEXT,
          github TEXT,
          twitter TEXT,
          blog_url TEXT,
          image_url TEXT,
          biography TEXT);
      SQL
      DB[:conn].execute(sql)
    end


    def self.drop_table
        sql = <<-SQL
          DROP TABLE students
        SQL
        DB[:conn].execute(sql)
    end

    def insert
        sql = <<-SQL
        INSERT INTO students (name) VALUES (?)
        SQL
        DB[:conn].execute(sql, @name)
        find_id = <<-SQL
        SELECT last_insert_rowid() FROM students
        SQL
        self.id = DB[:conn].execute(find_id).join("").to_i
    end

### How do I delevelop a sense of which approaches are better, what's below (defining by row) or what's right after (iteration through row)

    # def self.new_from_db(row)
    #   student = Student.new
    #   student.id = row[0]
    #   student.name = row[1]
    #   student.tagline = row[2]
    #   student.github = row[3]
    #   student.twitter = row[4]
    #   student.blog_url = row[5]
    #   student.image_url = row[6]
    #   student.biography = row[7]
    #   student
    # end

    def self.new_from_db(row)
      attributes = ["id", "name", "tagline", "github", "twitter", "blog_url", "image_url", "biography"]

      student = Student.new
      x = 0
      until x == attributes.length - 1
        student.send("#{attributes[x]}=", row[x])
        x += 1
      end
      student
    end

    # def self.find_by_name(name)
      #  sql = <<-SQL
      #    SELECT * FROM students WHERE name = (?);
      #  SQL
    #
    #    row = DB[:conn].execute(sql, name)
    #    row[0] ? Student.new_from_db(row[0]) : nil
    #  end

    def update
        sql = "UPDATE students SET name = ? WHERE id = ?;"
        DB[:conn].execute(sql, @name, @id)
      end

    def save
      if !!id
        self.update
      else
        self.insert
      end
    end

    def self.find_by_name(name)
      sql = <<-SQL
      SELECT * FROM students WHERE name = (?);
      SQL
      student = DB[:conn].execute(sql, name).flatten
      if student[1]
        new_from_db(student)
      else
        nil
      end
    end
end

# binding.pry

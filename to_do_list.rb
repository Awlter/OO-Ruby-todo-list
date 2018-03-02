class Todo
  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? "X" : ' '}] #{title}"
  end
end

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todo = []
  end

  def <<(todo)
    raise TypeError, 'can only add Todo objects' unless todo.instance_of? Todo
    
    @todo << todo
  end
  alias_method :add, :<<

  def each
    @todo.each { |todo| yield(todo) }
    self
  end

  def select
    result = TodoList.new(title)

    each do |todo|
      result << todo if yield(todo)
    end

    result
  end

  def size
    @todo.size
  end

  def last
    @todo.last
  end

  def first
    @todo.first
  end

  def mark_done_at(idx)
    @todo[idx].done!
  end

  def mark_undone_at(idx)
    @todo[idx].undone!
  end

  def done?
    @todo.all? { |item| item.done? }
  end

  def done!
    @todo.each_index { |index| mark_done_at(index) }
  end

  def shift
    @todo.shift
  end

  def pop
    @todo.pop
  end

  def item_at(index)
    @todo.fetch(index)
  end

  def remove_at(index)
    @todo.delete(item_at(index))
  end

  def find_by_title(event)
    select { |item| item.title == event }.first
  end

  def all_done
    select { |item| item.done? }
  end

  def all_not_done
    select { |item| !item.done? }
  end

  def mark_done(event)
    find_by_title(event) && find_by_title(event).done!
  end

  def mark_all_done
    each do |item|
      item.done!
    end
  end

  def mark_all_undone
    each do |item|
      item.undone!
    end
  end

  def to_a
    @todo
  end

  def to_s
    text = "---- #{title} ----\n"
    text << @todo.map(&:to_s).join("\n")
    text
  end
end

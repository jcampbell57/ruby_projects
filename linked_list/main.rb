# frozen_string_literal: true

require_relative 'lib/linked_list'

ll = LinkedList.new
# ll.append(400)
ll.prepend(200)
ll.prepend(100)
ll.append(400)
ll.insert_at(300, 2)
ll.insert_at(350, -2)
p ll.pop
ll.at(3)
ll.insert_at(400, 4)
ll.insert_at(50, 0)
p ll.contains?(400)
ll.insert_at(500, 100)
p ll.contains?(500)
p ll.size
ll.remove_at(5)
ll.remove_at(0)
ll.remove_at(2)
ll.remove_at(10)
p ll.to_s
p ll

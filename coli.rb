#!/usr/bin/env ruby

liabilities = [
  'address', 'bank account', 'employer', 'landlord',
  'health insurance', 'liability insurance',
  'internet provider', 'telephone number', 'cellphone number',
  'email address', 'web domain',
  'twitter account', 'facebook account', 'reddit account'
]
graph = {}

def yes?; gets.chars.first.downcase == 'y'; end

liabilities.each_with_index do |liability,idx|
  print "#{idx+1}/#{liabilities.size} Do you have a #{liability}? (y/n) "
  graph[liability] = [] if yes?
end

puts

loop do
  print "Do you want to add another liability? (y/n) "
  break unless yes?
  print "What liability do you want to add? "
  graph[gets.strip] = []
end

puts

graph.keys.each do |liability1|
  graph.keys.each do |liability2|
    next if liability1 == liability2
    print "Does your #{liability1} need your #{liability2}? (y/n) "
    graph[liability1] << liability2 if yes?
  end
end

puts

File.open('coli.dot','w') do |f|
  f.puts 'digraph coli {'
  graph.each_pair do |liability1, liabilities|
    liabilities.each do |liability2|
      f.puts "\"#{liability1}\" -> \"#{liability2}\";"
    end
  end
  f.puts '}'
end

puts 'All done! Generating output ... coli.dot, coli_dot.png, coli_circo.png'
`dot -Tpng coli.dot -ocoli_dot.png && circo -Tpng coli.dot -ocoli_circo.png`


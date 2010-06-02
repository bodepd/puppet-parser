#!/usr/bin/ruby
require 'puppet'

class ParseManifest

  @classes
  @code
  @resources

  def initialize()
    obj=Puppet::Parser::Interpreter.new.parser('Production')
    @code=obj.instance_eval do @loaded_code end
    @classes=@code.hostclasses
    @resources = Hash.new
  end

  def process_classes()
    @classes.each do |k, v|
      process_class(k, v.code)
    end
  end

  def process_class(name, code)
    puts "=====#{name}"
    code.each do |ast|
      #puts ast.class
#p @resources.class
      #puts ast.to_yaml
      @resources[name] = Array.new
      if ast.class.to_s == 'Puppet::Parser::AST::Resource'
puts ast.title.value
        @resources[name].push ast 
      # this is straigt up confusing
      elsif ast.class.to_s == 'Puppet::Parser::AST::ASTArray'
        ast.each do |element|
          puts element.class 
        end
      end
    end
  end

  #
  # gather all related resource types into array of their type
  #

  def process_ast(ast)
    puts ast.class
    puts ast.to_yaml
  end

  #
  # checks for missing resoufce defaults.
  #
  # takes a scope, returns a report.
  #
  def check_missing_defaults(scope)
    
  end

end


# first argument is the puppet source file
Puppet[:manifest]=ARGV[0]
report=ParseManifest.new()
report.process_classes

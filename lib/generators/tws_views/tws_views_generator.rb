# lib/generators/tws_views/tws_views_generator.rb

# see:
# http://edgeguides.rubyonrails.org/generators.html
# http://asciicasts.com/episodes/218-making-generators-in-rails-3
# http://rdoc.info/github/wycats/thor/master/Thor/Actions

require 'rails/generators/resource_helpers'


class TwsViewsGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers

  source_root File.expand_path('../templates', __FILE__)
  argument :view_name, :type => :string, :default => "all"
  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
  # argument :model_attributes, type: :array, default: [], banner: "model:attributes"
  
  # argument :attributes, :type => :array, :default => ['description:string', 'editable:boolean', 'deactivated:boolean', 'component_type_id:integer', 'default_id:integer'], :banner => "field:type field:type"
  # argument :attributes, :type => :array, :default => public_get_attributes, :banner => "field:type field:type"
  
  # access to validators through @model._validators
  # access to accessible attributes through @model._accessible_attributes and @model.._protected_attributes
  #    @model._accessible_attributes[:default].each { |attrib| puts attrib }

  
  def initialize(*args, &block)
    # load up attributes from model automatically, if not supplied
    # todo - detect attributes that are not accessible, and either not output them, or tell generator to show only
    # -> http://stackoverflow.com/questions/6285312/how-to-get-at-generatedattribute-in-a-custom-controller-generator
    super
    @attributes = []
    
    # code to allow user to override the choice of the parent foreign key table
    # e.g. rails generate tws_views ClassName ParentClassName:parent
    @tws_views_parent_association = ''
    @tws_views_child_association = file_name.underscore
    parent_association = ''
    child_association = ''
    # Rails.logger.debug("G args: #{args.inspect.to_s}")
    # Rails.logger.debug("G args[0]: #{args[0].inspect.to_s}")
    if !args[0].nil? && args[0].is_a?(Array)
      args[0].each do |arg|
        attrib = arg.split(":")
        if !arg.nil? && attrib.size > 0 && !attrib[1].nil?
          if attrib[1].downcase == 'parent'
            Rails.logger.debug("G parent is #{attrib[0].to_s}")
            parent_association = attrib[0].to_s.underscore
          elsif attrib[1].downcase == 'child'
            Rails.logger.debug("G child is #{attrib[0].to_s}")
            child_association = attrib[0].to_s.underscore
          end
        end
      end
    end
    
    if attributes.size > 0
      Rails.logger.debug("G attributes: #{attributes.inspect.to_s}")
      attributes.each do |attribute|
        @attributes << Rails::Generators::GeneratedAttribute.new(*attribute.split(":")) if attribute.include?(":")
      end
    else
      # Rails.logger.debug("G Load attributes from #{file_name.capitalize.constantize.columns.map.inspect.to_s}")
      my_model = file_name.camelize.constantize
      # my_model_instance = my_model.new
      attributes = my_model.columns.map do |c|
        foreign_key_field =  c.name.gsub(/_id/, '')
        if foreign_key_field != c.name
          attrib = Rails::Generators::GeneratedAttribute.new(c.name, 'reference')
          # attrib_pair = "#{c.name}:#{c.type}"
          Rails.logger.debug("G automatically generate field #{attrib.name.to_s}:#{attrib.type.to_s}")
          @attributes << attrib # if (my_model._accessible_attributes[:default].include?(attrib)
          # Field name of format xxxxx_id, indicating a foreign key.  Let see if we can display the class for it.
          # Rails.logger.debug("* G TwsViewsGenerator.initialize - c.name = #{c.name}, foreign_key_field = #{foreign_key_field}")
          foreign_key_name = foreign_key_field.underscore
          # Rails.logger.debug("* G TwsViewsGenerator.initialize - foreign_key_name = #{foreign_key_name}")
          # set first association to parent by default
          @tws_views_parent_association = foreign_key_name if @tws_views_parent_association.blank?
          if foreign_key_name == parent_association
            @tws_views_parent_association = foreign_key_name
          elsif foreign_key_name == child_association
            @tws_views_child_association = foreign_key_name
          end
          fk_attrib = Rails::Generators::GeneratedAttribute.new(foreign_key_name, 'association')
          Rails.logger.debug("G automatically generate field #{foreign_key_name}:#{fk_attrib.type.to_s}")
          @attributes << fk_attrib
        else
          attrib = Rails::Generators::GeneratedAttribute.new(c.name, c.type)
          # attrib_pair = "#{c.name}:#{c.type}"
          Rails.logger.debug("G automatically generate field #{attrib.name.to_s}:#{attrib.type.to_s}")
          @attributes << attrib # if (my_model._accessible_attributes[:default].include?(attrib)
        end
      end
    end
  end
  
  
  
  def copy_files
    if view_name == "all"
      # loop through all files in templates directory
      Dir.foreach(get_first_source_path) do |filename|
        if File.directory?(filename)
          # Rails.logger.debug( "Ignore sub-directories" )
        else
          clean_filename = Pathname.new(filename).basename.to_s
          Rails.logger.debug( "Got filename: #{clean_filename}" )
          process_file(clean_filename)
        end
      end
    else
      # generate a template for the view_name file
      # copy_file "#{view_name.underscore}.html.erb", "app/views/"
      Rails.logger.debug( "Checking view_name: #{get_first_source_path.to_s+'/'+view_name}" )
      if File.exists?(get_first_source_path+'/'+view_name)  # 
        Rails.logger.debug( "Got view_name: #{view_name.inspect.to_s}" )
        process_file(view_name)
      end
    end
    
  end
  
  # def list_source_paths
  #   source_paths.each do |source|
  #     Rails.logger.debug( "Possible Source Path = #{source.inspect.to_s}" )
  #     source_file = File.expand_path(File.join(source, '.'))
  #     if File.exists?(source_file)
  #       my_source_abs_path = Pathname.new(source_file)
  #       Rails.logger.debug( "my_source_abs_path = #{my_source_abs_path}" )
  #     end
  #   end
  # end

  # private methods only to be called by public methods
  private
  
  def get_first_source_path
    source_paths.each do |source|
      source_file = File.expand_path(File.join(source, '.'))
      return source_file if File.exists?(source_file)
    end
  end
  
  def get_first_source_rel_path
    source_paths.each do |source|
      source_file = File.expand_path(File.join(source, '.'))
      if File.exists?(source_file)
        my_base_path = Pathname.new(File.expand_path('.'))
        # Rails.logger.debug("my_base_path = #{my_base_path}")
        my_source_abs_path = Pathname.new(source_file)
        # Rails.logger.debug( "my_source_abs_path = #{my_source_abs_path}" )
        return Pathname.new(source_file).relative_path_from(my_base_path)
      end
    end
  end
  
  def get_rel_destination_path
    return "app/views/#{plural_name}"
  end
  
  def process_file(filename)
    Rails.logger.debug("G Process file: #{filename}")
    if filename.to_s.match('.*erb$')
      Rails.logger.debug( "Is an erb - #{get_rel_destination_path}/#{filename}" )
      template filename, "#{get_rel_destination_path}/#{filename}"
    elsif view_name.to_s.match('.*\.rb$')
      Rails.logger.debug( "ruby file" )
      copy_file filename, "#{get_rel_destination_path}/#{filename}"
      # template filename, "#{get_rel_destination_path}/#{filename}"
    else
      Rails.logger.debug( "regular file" )
    end
  end

end

# Overview

This ruby gem is a Rails Engine for using the Houdini Mechanical Turk API. It provides easy integration into your models and sets up the necessary controllers to receive answers posted back to your app from Houdini.

Check out the [Houdini Documentation](http://houdini.tenderapp.com/kb/developer-docs/api-v1) for more info about the API.

# Installation (Rails 3.x)

Add the gem to your Gemfile

    gem 'houdini'

Configure a few constants in config/initializers/houdini.rb

    Houdini.setup :sandbox, :api_key => 'YOUR_API_KEY', :app_host => 'https://your-app-domain.com'

You may want to configure Houdini differently for each of you environments.

# Example Usage

Request a beta account at http://houdiniapi.com to gain access to the Houdini Blueprint Editor.

Setup Houdini in your ActiveRecord model:

    class Post < ActiveRecord::Base
      include Houdini::Model

      houdini :image_moderation,
        :input => {
          :image_url => :image_url,                          # call the input_url method for
          :image_caption => lambda{ self.caption.titleize }, # use a lambda, called in the model's context
          :image_size => "100x100"                           # just send this string 
        },
        :on => :after_create,
        :on_task_completion => :process_image_moderation_answer

      def process_image_moderation_answer(params, verbose={})
        update_attribute :flagged => params[:category] == 'flagged'
      end
    end

# Usage

`houdini(blueprint, options)`

* `blueprint` - The name of the Houdini blueprint to use. Must be symbol or string.
* `options` - Hash of options to use.

## Options
* `:input` - Required. Hash: any task specific info needed to populate your blueprint. Keys must match the blueprint's required input, and values must a `Symbol` of the method to call, a lambdas/procs to be called in the model's context, or just a value to send along.
* `:on_task_completion` - Method that should be called when the answer is posted back to your app. Can be a symbol or a lambda/proc. The method will be called with a hash of the returned output from Houdini.
* `:on` - Name of a callback to use in order to trigger the submission to Houdini. Must be a symbol/string. If you don't want to use a callback, call the model instance's `houdini_submit_#{blueprint}!` method, where `blueprint` is the first argument you provided for the `houdini` method.
* `:after_submit` - Method that should be called after submitting the task to Houdini. Can be a symbol or a lambda/proc.
* `:id_method` - Method to get an identifier for the object. It is `id` by default, but you may want to use `to_param` with your app. Can be a symbol or lambda/proc. Use this in conjunction with `:finder`.
* `:finder` - Method by which to find the model by an identifier. It is `find` by default. Can be a symbol or lambda/proc.  Use this in conjunction with `:id_method`.

## Credits

* Thanks to Mike Nicholaides (https://github.com/nicholaides) for a huge refactoring to bring the gem up to date with the new version of Houdini.

## License

MIT License. Copyright 2012 Houdini Inc. http://houdiniapi.com

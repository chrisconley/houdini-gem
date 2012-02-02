# Overview

This ruby gem is a Rails Engine for using the Houdini Mechanical Turk API. It provides easy integration into your models and sets up the necessary controllers to receive answers posted back to your app from Houdini.

Check out the [Houdini Documentation](http://houdiniapi.com/documentation) for more info about the API.

# Installation (Rails 3.x)

Add the gem to your Gemfile

    gem 'houdini'

Configure a few constants in config/initializers/houdini.rb

    Houdini.setup :sandbox, :api_key => 'YOUR_API_KEY', :app_host => 'https://your-app-domain.com'

You may want to configure Houdini differently for each of you environments.

# Example Usage

Create a task design at [TBD]

Setup Houdini in your ActiveRecord model:

    class Post < ActiveRecord::Base
      include Houdini::Model

      houdini :image_moderation, # blueprint to use
        :input => {
          :image_url => :image_url
        },
        :after_submit => :update_houdini_attributes,
        :on_task_completion => :process_image_moderation_answer

      after_create{ Houdini.perform! :image_moderation, self }

      def update_houdini_attributes
        update_attribute :houdini_request_sent_at, Time.now
      end

      def process_image_moderation_answer(params)
        update_attribute :flagged => params[:category] == 'flagged'
      end
    end


Post.houdini class method options:

* `:input` - Hash: any task specific info needed to populate your blueprint. Keys must match the blueprint's required input.
* `:after_submit` - Method that should be called after submitting the task to Houdini.
* `:on_task_completion` - Method that should be called when the answer is posted back to your app.
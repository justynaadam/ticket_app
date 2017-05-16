# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_170_315_190_356) do
  create_table 'categories', force: :cascade do |t|
    t.string   'text'
    t.integer  'main_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['main_id'], name: 'index_categories_on_main_id'
  end

  create_table 'relationships', force: :cascade do |t|
    t.integer  'follower_id'
    t.integer  'followed_id'
    t.datetime 'created_at',  null: false
    t.datetime 'updated_at',  null: false
    t.index ['followed_id'], name: 'index_relationships_on_followed_id'
    t.index %w[follower_id followed_id], name: 'index_relationships_on_follower_id_and_followed_id', unique: true
    t.index ['follower_id'], name: 'index_relationships_on_follower_id'
  end

  create_table 'searches', force: :cascade do |t|
    t.string   'keywords'
    t.integer  'category_id'
    t.float    'minimum_price'
    t.float    'maximum_price'
    t.string   'location_keywords'
    t.datetime 'created_at',                        null: false
    t.datetime 'updated_at',                        null: false
    t.boolean  'in_content',        default: false
    t.boolean  'with_picture',      default: false
    t.string   'type_of_ticket'
    t.integer  'searched_user'
    t.integer  'user_id'
    t.datetime 'time'
    t.index ['user_id'], name: 'index_searches_on_user_id'
  end

  create_table 'tickets', force: :cascade do |t|
    t.text     'title'
    t.text     'content'
    t.decimal  'price', precision: 8, scale: 2
    t.string   'ticket_type'
    t.integer  'user_id'
    t.datetime 'created_at',                                null: false
    t.datetime 'updated_at',                                null: false
    t.string   'location'
    t.integer  'category_id'
    t.string   'picture'
    t.string   'activation_digest'
    t.boolean  'activated'
    t.datetime 'activated_at'
    t.index ['category_id'], name: 'index_tickets_on_category_id'
    t.index %w[user_id created_at], name: 'index_tickets_on_user_id_and_created_at'
    t.index %w[user_id id], name: 'index_tickets_on_user_id_and_id'
    t.index ['user_id'], name: 'index_tickets_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string   'email',                  default: '',    null: false
    t.string   'encrypted_password',     default: '',    null: false
    t.string   'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.string   'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string   'unconfirmed_email'
    t.datetime 'created_at',                             null: false
    t.datetime 'updated_at',                             null: false
    t.string   'name'
    t.integer  'phone'
    t.boolean  'admin', default: false
    t.index ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end
end

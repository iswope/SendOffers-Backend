# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121015110212) do

  create_table "ads", :force => true do |t|
    t.integer  "client_id"
    t.integer  "blast_id"
    t.date     "blast_date"
    t.string   "description"
    t.string   "supp_art"
    t.string   "dist_art"
    t.integer  "active"
    t.date     "start"
    t.date     "end"
    t.string   "status"
    t.string   "subject_line"
    t.string   "imagemap"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "clients", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "company"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone"
    t.string   "fax"
    t.string   "mailing_address"
    t.string   "mailing_address2"
    t.string   "mailing_city"
    t.string   "mailing_state"
    t.string   "mailing_zip"
    t.string   "mailing_country"
    t.string   "shipping_address"
    t.string   "shipping_address2"
    t.string   "shipping_city"
    t.string   "shipping_state"
    t.string   "shipping_zip"
    t.string   "shipping_country"
    t.string   "web"
    t.string   "admin_notes"
    t.string   "leadname"
    t.string   "leademail"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "role"
    t.string   "sopass"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end

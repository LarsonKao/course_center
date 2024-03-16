# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create(
    name: 'test_client',
    redirect_uri: '',
    scopes: '',
    uid: '11rD_NPUo9D15hrTuFfgege3iAabZn9gfgnBlEw2',
    secret: 'tSeKtHSQ5x3JJgE57QNHrAjL2Tcy0UdjitxLi33ITQA'
  )
end

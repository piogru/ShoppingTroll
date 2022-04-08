# ShoppingTroll - Ragnarson internship project

Web application for managing shopping lists:
* manage shopping lists 
* share shoppings lists with other users
* find products by shops or categories
* compare product prices
* review shops
* API suggesting a shopping list based on recipe ingredients received in json from another application

## Requirements
* Ruby version: 2.7.4p191
* Rails version: 6.1.4.1

## System dependencies
* PostGreSQL DB

## Database creation
`rails db:create:all`

## Database initialization
Fill database with example data
`rails db:seed`

## How to run the test suite
`bundle exec rspec`

## My contributions include
* Creating review and shopping list related models and relationships
* Shop listing and details
* Capacity calculator service
* Adding products to shopping lists
* Shopping list item CRUD
* Creating API endpoint
* Rails_admin_import gem setup for adding multiple products and linking them with shops using .csv files
* Configuring RSpec and factory_bot gems
* Configuring Rubocop and lefthook pre-push spec trigger
* Model validation specs
* System specs for devise, product addtion to shoppings lists, review management

Tests are included with mentioned features where applicable.

## Screenshots
![Zrzut ekranu 2022-04-08 202549](https://user-images.githubusercontent.com/81086063/162510333-f5f01b49-1177-4cb2-be96-d6f16863ffa2.jpg)
![Zrzut ekranu 2022-04-08 202609](https://user-images.githubusercontent.com/81086063/162510341-54e48294-0374-48f9-aac6-37b49268784f.jpg)
![Zrzut ekranu 2022-04-08 202640](https://user-images.githubusercontent.com/81086063/162510343-fd629d3f-e1ee-4f80-b215-5171926e3d11.jpg)
![Zrzut ekranu 2022-04-08 202733](https://user-images.githubusercontent.com/81086063/162510345-9cf3e545-1fae-402e-8682-cf700c04fc08.jpg)
![Zrzut ekranu 2022-04-08 202842](https://user-images.githubusercontent.com/81086063/162510347-6eebdaa8-a282-48a1-a83b-d50926d461ce.jpg)
![Zrzut ekranu 2022-04-08 202903](https://user-images.githubusercontent.com/81086063/162510349-32cd436b-c623-4f9d-8902-318a50ceb0b9.jpg)
![Zrzut ekranu 2022-04-08 202918](https://user-images.githubusercontent.com/81086063/162510350-56217d60-8b4a-4916-9a5d-f4428f389f59.jpg)
![Zrzut ekranu 2022-04-08 202932](https://user-images.githubusercontent.com/81086063/162510352-a4766f73-2142-418e-9b25-d896f49a1e4c.jpg)

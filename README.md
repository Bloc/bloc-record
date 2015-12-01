(under construction)

How to use:

1) Clone and bundle install

2) Use with [AddressBlocWithDB](https://github.com/Bloc/address-bloc-with-db). It's already got the database ready to go. Then write a driver file like:

```ruby
require_relative 'models/address_book'
require_relative 'models/entry'
require 'bloc_record'

BlocRecord.connect_to("db/address_bloc.db")

AddressBook.create(name: "My Addressbook")

entry = Entry.new(name: "ben neely", phone: "208-350-8855", email: "Ben@bloc.io")
entry.save!

book = AddressBook.new
book.name = "BLAAAA"
book.save!


p Entry.find(entry.id)
p AddressBook.take(5)
```

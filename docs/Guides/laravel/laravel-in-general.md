# Artisan

Laravel Artisan is a command-line app which helps operate the framework. We can use
it to minimize the amount of boilerplate we write (by generating code from templates),
but we can also use it enable/disable maintenance mode, perform database changes, and
execute our own custom commands. 

## Very Cool Commands

    php artisan make:model Something -mcr

This command will create a model, migration, resource controller, seeder, factory,
form request, and authorization policy, all with naming conventions aligned to the
model name you provide (Singular). 

Laravel's discovery mechanism will automatically register the new classes if the
name meets convention, and the easiest way to ensure that is to use the generator
found in make:model. 

## Even Cooler Commands

You can write your own custom commands and use Artisan to call them, or you can 
invoke them from a model, controller, repository, etc. 

    php artisan make:command SomethingCommand


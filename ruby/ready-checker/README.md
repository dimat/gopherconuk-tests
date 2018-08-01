# Usage

In the `env.rb` file add the following:
```ruby
checks = [
  # Here will be your checks
]

Glint::ReadyChecker::Checker.wait_for checks
```

At the moment there are a few basic checks:

* `ServiceReadyCheck` - can be used for services that implement a ready check. Most of our Go services have it
* `UrlContentCheck` - a more generic checker that is used by `ServiceReadyCheck` and `ServiceHealthCheck`. 
Can take expected HTTP status code and optionally expected body.

For example, if you need to check when multiple services are ready, you can define it like this:

```ruby
  checks = [
      Glint::ReadyChecker::ServiceReadyCheck.new('api-service')
  ]
```
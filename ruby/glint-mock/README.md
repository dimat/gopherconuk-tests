To use the mock in your project, add the following line into `Gemfile`:
```
gem 'glint-mock', :git => 'ssh://git@bitbucket-dev.glintpay.com:7999/gw/ruby-glint-mock.git'
```

This repository contains two examples:

Folder `example` demonstrates using a simple mock from cucumber and it checks 
that after each test scenarios all mocks are shut down.

Folder `example-proxy` shows how several mocks can be run in the same docker container
  and then linked through a proxy by host name.
  
To run this example, go to `example-proxy` directory and run the following command:
```
docker-compose up --build
```

All hosts should be defined in `docker-compose.yml` file as following:
```
    extra_hosts:
      - mock1:127.0.0.1
      - mock2:127.0.0.1
```
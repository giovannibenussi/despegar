# Despegar crawler

Crawler that obtains despegar.com lowest prices from multiple trip dates

## Table of contents
- [Description](https://github.com/giovannibenussi/despegar#description)
- [Installation](https://github.com/giovannibenussi/despegar#installation)
- [Basic Usage](https://github.com/giovannibenussi/despegar#basic-usage)
- [Price ranges](https://github.com/giovannibenussi/despegar#price-ranges)
- [Examples](https://github.com/giovannibenussi/despegar#examples)

## Description
Script to obtain the lowest pricest from despegar.com website's. You can select any origin and destination city to trip and also a duration in days from your trip (including a margin from this).

## Installation
```sh
git clone https://github.com/giovannibenussi/despegar
cd despegar
bundle install
```

## Basic Usage:

```ruby
ruby get_trip_prices.rb -f FROM_CITY_CODE -t TO_CITY_CODE -d TRIP_DURATION_IN_DAYS
```

Where:
* FROM_CITY_CODE: [Short code](https://github.com/giovannibenussi/despegar/blob/master/city_codes.md) from origin city (e.g: SCL)
* TO_CITY_CODE: [Short code](https://github.com/giovannibenussi/despegar/blob/master/city_codes.md) from destination city (e.g: MIA)
* TRIP_DURATION_IN_DAYS: Duración del viaje en días (e.g: 14)

Optional:
* Margin in arrival date. For example, if arrival date is in 14 days, then the script will get the prices from day 13 to 15 if margin equals 1.

## Price ranges
If you want override the default price ranges (used to colorize prices) you can edit the file `config.yml`:
```yml
margin: 1
price_ranges:
    excessive: 600_000
    expensive: 500_000
    moderate: 450_000
    moderate_to_cheap: 400_000
    cheap: 300_000
```

## Examples:
* Get prices from SCL to MIA for a 14 days trip:
```ruby
ruby get_trip_prices.rb -f scl -t mia -d 14
```

* Get prices from SCL to MIA for a trip between 13 and 15 days:
```ruby
ruby get_trip_prices.rb -f scl -t mia -d 14 -m 1
```
* Get prices from SCL to MIA for a trip between 12 and 16 days:
```ruby
ruby get_trip_prices.rb -f scl -t mia -d 14 -m 2
```

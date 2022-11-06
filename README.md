# DateTimeLib

[![NPM][npm-shield]][npm-url]
[![CI][ci-shield]][ci-url]
[![MIT License][license-shield]][license-url]

Gas-Efficient Solidity DateTime Library

## Conventions

All dates, times and Unix timestamps are [UTC](https://en.wikipedia.org/wiki/Coordinated_Universal_Time).

Unit           | Range                         | Notes
:------------- |:---------------------------:  |:---------------------------------------------------------------
timestamp      | >= 0                          | Unix timestamp, number of seconds since 1970/01/01 00:00:00 UTC
month          | 1 ... 12                      |
day            | 1 ... 31                      |
Weekday        | 0 ... 6                       | 0 = Monday, ..., 6 = Sunday
year/month/day | 1970/01/01 . 3.66*10^69/12/31 |

All functions operate on the `uint256` timestamp data type.

<br />

<hr />

## Functions

### daysFromDate
Calculate the number of days `days` from 1970/01/01 to `year`/`month`/`day`.

```javascript
function daysFromDate(uint256 y, uint256 m, uint d) public pure returns (uint256 day)
```

**NOTE** This function does not validate the `year`/`month`/`day` input. Use [`isValidDate(...)`](#isvaliddate) to validate the input if necessary.

<br />

### daysToDate

Calculate `year`/`month`/`day` from the number of days `days` since 1970/01/01 .

```javascript
function daysToDate(uint256 _days) public pure returns (uint256 year, uint256 month, uint256 day)
```

<br />

### timestampFromDate

Calculate the `timestamp` to `year`/`month`/`day`.

```javascript
function timestampFromDate(uint256 year, uint256 month, uint256 day) public pure returns (uint timestamp)
```

**NOTE** This function does not validate the `year`/`month`/`day` input. Use [`isValidDate(...)`](#isvaliddate) to validate the input if necessary.

<br />


### timestampToDate

Calculate `year`/`month`/`day` from `timestamp`.

```javascript
function timestampToDate(uint256 t) public pure returns (uint256 y, uint256 m, uint256 d)
```

### isValidDate

Is the date specified by `year`/`month`/`day` a valid date?

```javascript
function isValidDate(uint256 year, uint256 month, uint256 day) internal pure returns (bool valid)
```

<br />

### getDaysInMonth

Return number of day in the month `daysInMonth` for the month specified by `year`/`month`.

```javascript
function getDaysInMonth(uint256 y, uint256 m) internal pure returns (uint256 d)
```

<br />

### getDayOfWeek

Return the day of the week `weekday` (0 = Monday,1 = Tuesday ..., 6 = Sunday) for the date specified by `timestamp`.

```javascript
function getWeekDay(uint256 t) internal pure returns (uint256 weekday) 
```

<br />

### getNthDayOfWeekInMonthOfYear

Return `timestamp` of the Nth dayOfWeek from the `year`/`month`.

```javascript
function getNthDayOfWeekInMonthOfYear(uint256 y, uint256 m, uint256 n, uint256 wd) internal pure returns (uint256 t)
```
**NOTE** This function does not validate the `year`/`month` and `wd` input. Use [`isValidDate(...)`](#isvaliddate) to validate for `year`/`month` and `wd` must be in range of [0,6].

**Example :**
```javascript
// get 3th Friday of November 2022
getNthDayOfWeekInMonthOfYear(2022,11,3,4) -> 1668729600  //18th November 2022 00:00:00 UTC
```
<br />

### getNextWeekDay

Return `timestamp` of next week day from `timestamp` and `wd`.

```javascript
function getNextWeekDay(uint256 t, uint256 wd) internal pure returns (uint256 _timestamp)
```
**Example :**
```javascript
// get next friday (current date is 6th November 2022)
getNextWeekDay(1667724375,4) -> 1668124800  //11th November 2022 00:00:00 UTC
```

## Safety

This is **experimental software** and is provided on an "as is" and "as available" basis.

We **do not give any warranties** and **will not be liable for any loss** incurred through any use of this codebase.

## Installation

To install with [**Foundry**](https://github.com/gakonst/foundry):

```sh
forge install Atarpara/DateTimeLib
```

To install with [**Hardhat**](https://github.com/nomiclabs/hardhat) or [**Truffle**](https://github.com/trufflesuite/truffle):

```sh
npm install
```

## Acknowledgements

This repository is inspired by or directly modified from many sources, primarily:
- [solady](https://github.com/Vectorized/solady)
- [BokkyPooBahsDateTimeLibrary](https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary)


## References

A copy of the webpage with the algorithm [Date Time Algorithm](https://howardhinnant.github.io/date_algorithms.html).

[npm-shield]: https://img.shields.io/npm/v/@atarpara/datetimelib.svg
[npm-url]: https://www.npmjs.com/package/@atarpara/datetimelib

[ci-shield]: https://img.shields.io/github/workflow/status/atarpara/datetimelib/ci?label=build
[ci-url]: https://github.com/atarpara/datetimelib/actions/workflows/ci.yml

[license-shield]: https://img.shields.io/badge/License-MIT-green.svg
[license-url]: https://github.com/vectorized/solady/blob/main/LICENSE.txt

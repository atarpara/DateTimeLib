# DateTimeLib

[![NPM][npm-shield]][npm-url]
[![CI][ci-shield]][ci-url]
[![MIT License][license-shield]][license-url]

Gas-Efficient Solidity DateTime Library

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

## Conventions

All dates, times and Unix timestamps are [UTC](https://en.wikipedia.org/wiki/Coordinated_Universal_Time).

Unit           | Range                         | Notes              |
:------------- |:---------------------------:  |:------------------ |
timestamp | 0..0x1e18549868c76ff | Unix timestamp.                  |
epochDay  | 0..0x16d3e098039     | Days since 1970-01-01.           |
year      | 1970..0xffffffff     | Gregorian calendar year.         |
month     | 1..12                | Gregorian calendar month.        |
day       | 1..31                | Gregorian calendar day of month. |
weekday   | 1..7                 | The day of the week (1-indexed). |

All functions operate on the `uint256` timestamp data type.

<br />

<hr />

## Functions

### dateToEpochDay
Calculate the number of days `days` from 1970/01/01 to `year`/`month`/`day`.

```javascript
function dateToEpochDay(uint256 year, uint256 month, uint256 day) internal pure returns (uint256 epochDay)
```

**NOTE** This function does not validate the `year`/`month`/`day` input. Use [`isSupportedDate(..)`](#isSupportedDate) to validate the input if necessary.

Example: 

```javascript
    if(DateTimeLib.isSupportedDate(1970,2,1))
        uint256 day = DateTimeLib.dateToEpochDay(1970,2,1) // returns 31 day
    if(DateTimeLib.isSupportedDate(1971,1,1))
        uint256 day = DateTimeLib.dateToEpochDay(1971,1,1) // returns 365 day
```
<br />

### epochDayToDate

Calculate `year`/`month`/`day` from the number of days `days` since 1970/01/01 .

```javascript
function epochDayToDate(uint256 epochDay) internal pure returns (uint256 year, uint256 month, uint256 day)
```
**NOTE** This function does not validate the `epochDay` input. Use [`isSupportedEpochDay(..)`](#isSupportedEpochDay) to validate the input if necessary.

Example: 

```javascript
    if(DateTimeLib.isSupportedEpochDay(0))
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.dateToEpochDay(0) // 1970-01-01
    if(DateTimeLib.isSupportedEpochDay(224))
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.dateToEpochDay(224) // 1970-08-13
```
<br />

### dateToTimestamp

Calculate the `timestamp` from `year`/`month`/`day`.

```javascript
function dateToTimestamp(uint256 year, uint256 month, uint256 day) internal pure returns (uint256 result)
```

**NOTE** This function does not validate the `year`/`month`/`day` input. Use [`isSupportedDate(...)`](#isSupportedDate) to validate the input if necessary.

Example: 

```javascript
    if(DateTimeLib.isSupportedDate(1970,2,1))
        uint256 timestamp = DateTimeLib.dateToTimestamp(1970,2,1) // returns 2658600
    if(DateTimeLib.isSupportedDate(2022,11,10))
        uint256 timestamp = DateTimeLib.dateToTimestamp(2022,11,10) // returns 1668018600
```

<br />

### timestampToDate

Calculate `year`/`month`/`day` from `timestamp`.

```javascript
function timestampToDate(uint256 timestamp) internal pure returns (uint256 year, uint256 month, uint256 day)
```
**NOTE** This function does not validate the `timestamp` input. Use [`isSupportedTimestamp(...)`](#isSupportedTimestamp) to validate the input if necessary.

Example: 

```javascript
    if(DateTimeLib.isSupportedTimestamp(2658650))
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(2658600) // returns 1970-02-01
    if(DateTimeLib.isSupportedTimestamp(1668018900))
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(1668018900) // returns 2022-11-10
```

<br />

### dateTimeToTimestamp

Calculate `timestamp` from `year`/`month`/`day`/`hour`/`minute`/`second`.

```javascript
function dateTimeToTimestamp(uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) internal pure returns (uint256 result)
```
**NOTE** This function does not validate the  `year`/`month`/`day`/`hour`/`minute`/`second` input. Use [`isSupportedDateTime(...)`](#isSupportedDateTime) to validate the input if necessary.

Example: 

```javascript
    if(DateTimeLib.isSupportedDateTime(1970,02,01,23,30,59))
        uint256 timestamp = DateTimeLib.dateTimeToTimestamp(1970,02,01,23,30,59) // returns 2763059
    if(DateTimeLib.isSupportedDateTime(2022,11,10,06,47,30))
        uint256 timestamp = DateTimeLib.dateTimeToTimestamp(2022,11,10,12,17,30) // returns 1668062850
```

<br />

### timestampToDateTime

Calculate `year`/`month`/`day`/`hour`/`minute`/`second` from  `timestamp`.

```javascript
function timestampToDateTime(uint256 timestamp) internal pure returns (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second)
```
**NOTE** This function does not validate the  `year`/`month`/`day`/`hour`/`minute`/`second` input. Use [`isSupportedTimestamp(...)`](#isSupportedTimestamp) to validate the input if necessary.

Example: 

```javascript
    if(DateTimeLib.isSupportedTimestamp(2763059))
        (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) = DateTimeLib.timestampToDateTime(2763059) // returns 1970-02-01 23:30:59
    if(DateTimeLib.isSupportedTimestamp(1668062850))
        (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) = DateTimeLib.timestampToDateTime(1668062850) // returns 2022-11-10 12:17:30
```

<br />

### isLeapYear

Check given year is leap or not.

```javascript
function isLeapYear(uint256 year) internal pure returns (bool leap) 
```
Example: 

```javascript
    bool isLeap = DateTimeLib.isLeapYear(1900) // returns False
    bool isLeap = DateTimeLib.isLeapYear(2004) // returns True
    bool isLeap = DateTimeLib.isLeapYear(2400) // returns True
```

<br />

### daysInMonth

Return number of day in the month `daysInMonth` for the month specified by `year`/`month`.

```javascript
function daysInMonth(uint256 year, uint256 month) internal pure returns (uint256 result)
```
Example: 

```javascript
    uint256 day = DateTimeLib.daysInMonth(01, 1900) // returns 31
    uint256 day = DateTimeLib.daysInMonth(02, 2001) // returns 28
    uint256 day = DateTimeLib.daysInMonth(02, 2004) // returns 29
```

<br />

### weekday

Return the day of the week `weekday` (1 = Monday,2 = Tuesday ..., 7 = Sunday) for the date specified by `timestamp`.

```javascript
function weekday(uint256 timestamp) internal pure returns (uint256 result)
```
<br />

### isSupportedDate

Check the given date is valid or not.
```javascript
function isSupportedDate(uint256 year, uint256 month, uint256 day) internal pure returns (bool result)
```
**NOTE** This algorithm supported fully uint256 limit but Restricted max supported year to type(uint32).max. By the time, we will already be either extinct, an interstellar species, or the Earth's motion would have drastically changed. A smaller supported range will mean smaller bytecode needed to validate the dates.

<br />

### isSupportedDateTime

Check the given datetime is valid or not.
```javascript
function function isSupportedDateTime(uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) internal pure returns (bool result)
```

<br />

### isSupportedEpochDay

Check the given epoch day is valid or not.
```javascript
function isSupportedEpochDay(uint256 epochDay) internal pure returns (bool result)
```
**NOTE** This algorithm supported fully uint256 limit but Restricted max supported epochDay to `MAX_SUPPORTED_EPOCH_DAY`. By the time, we will already be either extinct, an interstellar species, or the Earth's motion would have drastically changed.

<br />

### isSupportedTimestamp

Check the given timestamp is valid or not.
```javascript
function isSupportedTimestamp(uint256 timestamp) internal pure returns (bool result)
```
**NOTE** This algorithm supported fully uint256 limit but Restricted max supported timstamp to `MAX_SUPPORTED_TIMESTAMP`.

<br />

### nthWeekdayInMonthOfYearTimestamp

Return `timestamp` of the Nth weekday from the `year`/`month`.

```javascript
function nthWeekdayInMonthOfYearTimestamp(uint256 year, uint256 month, uint256 n, uint256 wd) internal pure returns (uint256 result)
```
**NOTE** This function does not validate the `year`/`month` and `wd` input. Use [`isSupportedDate(year,month,1)`](#isSupportedDate) to validate for `year`/`month` and `wd` must be in range of [1,7].

Example: 

```javascript
    uint256 timestamp = DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2022,12,1,DateTimeLib.FRI) // returns 1669939200 (1st Friday December 2022)
    uint256 timestamp = DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2022,11,6,DateTimeLib.WED) // returns 0 (6th Wednesday November 2022)
```


<br />

### mondayTimestamp
Calculate `timestamp` of the most recent Monday.

```javascript
function mondayTimestamp(uint256 timestamp) internal pure returns (uint256 result)
```
**NOTE** If timestamp < 345600 it returns 0 as per UTC it is thursday.

<br />

### isWeekEnd
Calculate `timestamp` falls on a Saturday or Sunday

```javascript
function isWeekEnd(uint256 timestamp) internal pure returns (bool result)
```

<br />

### addYears

Add `numYears` years to the date and time specified by timestamp.

Note that the resulting day of the month will be adjusted if it exceeds the valid number of days in the month. For example, if the original date is 2020/02/29 and an additional year is added to this date, the resulting date will be an invalid date of 2021/02/29. The resulting date is then adjusted to 2021/02/28.

```javascript
function addYears(uint256 timestamp, uint256 numYears) internal pure returns (uint256 result)
```
<br />

### addMonths

Add `numMonths` months to the date and time specified by timestamp.

Note that the resulting day of the month will be adjusted if it exceeds the valid number of days in the month. For example, if the original date is 2019/01/31 and an additional month is added to this date, the resulting date will be an invalid date of 2019/02/31. The resulting date is then adjusted to 2019/02/28.

```javascript
function addMonths(uint256 timestamp, uint256 numMonths) internal pure returns (uint256 result)
```

<br />

### addDays

Add `numDays` days to the date and time specified by timestamp.

```javascript
function addDays(uint256 timestamp, uint256 numDays) internal pure returns (uint256 result)
```


### addHours

Add `numHours` hours to the date and time specified by timestamp.

```javascript
function addHours(uint256 timestamp, uint256 numHours) internal pure returns (uint256 result)
```

<br />

### addMinutes

Add `numMinutes` minutes to the date and time specified by timestamp.

```javascript
function addMinutes(uint256 timestamp, uint256 numMinutes) internal pure returns (uint256 result)
```

<br />

### addSeconds

Add `numSeconds` seconds to the date and time specified by timestamp.

```javascript
function addSeconds(uint256 timestamp, uint256 numSeconds) internal pure returns (uint256 result)
```

<br />

### subYears

Subtracts `numYears` years from the unix timestamp.

Note that the resulting day of the month will be adjusted if it exceeds the valid number of days in the month. For example, if the original date is 2020/02/29 and a year is subtracted from this date, the resulting date will be an invalid date of 2019/02/29. The resulting date is then adjusted to 2019/02/28.

```javascript
function subYears(uint256 timestamp, uint256 numYears) internal pure returns (uint256 result)
```

<br />

### subMonths

Subtracts `numMonths` months from the unix timestamp.

Note that the resulting day of the month will be adjusted if it exceeds the valid number of days in the month. For example, if the original date is 2019/03/31 and a month is subtracted from this date, the resulting date will be an invalid date of 2019/02/31. The resulting date is then adjusted to 2019/02/28.

```javascript
function subMonths(uint256 timestamp, uint256 numMonths) internal pure returns (uint256 result)
```

<br />

### subDays

Subtracts `numDays` days from the unix timestamp.
```javascript
function subDays(uint256 timestamp, uint256 numDays) internal pure returns (uint256 result)
```

<br />

### subHours

Subtracts `numHours` from the unix timestamp.

```javascript
function subHours(uint256 timestamp, uint256 numHours) internal pure returns (uint256 result)
```

<br />

### subMinutes

Subtracts `numMinutes` from the unix timestamp.

```javascript
function subMinutes(uint256 timestamp, uint256 numMinutes) internal pure returns (uint256 result)
```

<br />

### subSeconds

Subtracts `numSeconds` from the unix timestamp.

```javascript
function subSeconds(uint256 timestamp, uint256 numSeconds) internal pure returns (uint256 result)
```

<br />

### diffYears

Calculate the number of years between the dates specified by `fromTimeStamp` and `toTimestamp`.

Note that Even if the true time difference is less than a year, the difference can be non-zero is the timestamps are from diffrent Gregorian calendar years.
```javascript
function diffYears(uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256 result)
```

<br />

### diffMonths

Calculate the number of months between the dates specified by `fromTimeStamp` and `toTimestamp`.

Note that Even if the true time difference is less than a month, the difference can be non-zero is the timestamps are from diffrent Gregorian calendar months.

```javascript
function diffMonths(uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256 result)
```

<br />

### diffDays

Calculate the number of days between the dates specified by `fromTimeStamp` and `toTimestamp`.
```javascript
function diffDays(uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256 result)
```

<br />

### diffHours

Calculate the number of hours between the dates specified by `fromTimeStamp` and `toTimestamp`.

```javascript
function diffHours(uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256 result)
```

<br />

### diffMinutes

Calculate the number of minutes between the dates specified by `fromTimeStamp` and `toTimestamp`.

```javascript
function diffMinutes(uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256 result)
```

<br />

### diffSeconds

Calculate the number of seconds between the dates specified by `fromTimeStamp` and `toTimestamp`.

```javascript
function diffSeconds(uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256 result)
```

<br />

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

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library DateTimeLib {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    uint256 constant PER_DAY_SECOND = 86400;

    /// @dev Returns days from 1970-01-01 to y-m-d using
    /// date conversion algorithm from
    /// https://howardhinnant.github.io/date_algorithms.html
    /// @notice doesn't validate date if date is before 1970-1-1 then this will give undefined behaviour
    /// you can validate date by isValidDate function
    function daysFromDate(
        uint256 y,
        uint256 m,
        uint256 d
    ) internal pure returns (uint256 day) {
        /// @solidity memory-safe-assembly
        assembly {
            y := sub(y, lt(m, 3))
            // (153*mp + 2)/5 equivalent (62719*mp + 769 / 2048)
            let doy := add(shr(11, add(mul(62719, mod(add(m, 9), 12)), 769)), d)
            let yoe := mod(y, 400)
            let doe := sub(add(add(mul(yoe, 365), shr(2, yoe)), doy), div(yoe, 100))
            day := sub(add(mul(div(y, 400), 146097), doe), 719469)
        }
    }

    /// @dev Returns year-month-day from the number of days since 1970-01-01
    function daysToDate(uint256 z)
        internal
        pure
        returns (
            uint256 year,
            uint256 month,
            uint256 day
        )
    {
        /// @solidity memory-safe-assembly
        assembly {
            z := add(z, 719468)
            let era := div(z, 146097)
            let doe := mod(z, 146097)
            let yoe := div(sub(add(doe, div(doe, 36524)), div(doe, 1460)), 365)
            let doy := add(sub(sub(doe, mul(365, yoe)), shr(2, yoe)), div(yoe, 100))
            let mp := div(add(mul(5, doy), 2), 153)
            day := add(sub(doy, shr(11, add(mul(mp, 62719), 769))), 1)
            month := add(sub(mp, 9), mul(lt(mp, 10), 12))
            year := add(add(yoe, mul(era, 400)), lt(month, 3))
        }
    }

    /// @dev Returns true if given year is leap year else false
    function isLeapYear(uint256 y) internal pure returns (bool valid) {
        /// @solidity memory-safe-assembly
        assembly {
            valid := and(iszero(and(y,0x03)),or(iszero(iszero(mod(y,100))),iszero(mod(y,400))))
        }
    }

    /// @dev Returns unix timestamp from given yyyy-m-d
    /// @notice doesn't validate date if date is before 1970-1-1 then this will give undefined behaviour
    /// you can validate date by isValidDate function
    function timestampFromDate(
        uint256 y,
        uint256 m,
        uint256 d
    ) internal pure returns (uint256 timestamp) {
        return daysFromDate(y, m, d) * PER_DAY_SECOND;
    }

    /// @dev Returns yyyy-m-d from the given timestamp
    function timestampToDate(uint256 timestamp)
        internal
        pure
        returns (
            uint256 y,
            uint256 m,
            uint256 d
        )
    {
        (y, m, d) = daysToDate(timestamp / PER_DAY_SECOND);
    }

    /// @dev Returns number of days in given month of year
    function monthDays(uint256 y, uint256 m) internal pure returns (uint256 d) {
        bool flag = isLeapYear(y);
        /// @solidity memory-safe-assembly
        assembly {
            // months[12] = [31,28,31,30,31,30,31,31,30,31,30,31]
            // day = month[m-1] + isLeapYear(y)
            d := add(byte(m, shl(152, 0x1F1C1F1E1F1E1F1F1E1F1E1F)), and(eq(m, 2), flag))
        }
    }

    /// @dev Returns Week Day of given timestamp
    /// Monday - 0, Tuesday - 1, ....., Sunday - 6
    function getWeekDay(uint256 t) internal pure returns (uint256 weekday) {
        /// @solidity memory-safe-assembly
        assembly {
            weekday := mod(add(div(t, PER_DAY_SECOND), 3), 7)
        }
    }

    /// @dev Returns If given date is valid else false
    /// valid range 1970 < year < 3.17*10^75, 0 < month < 13, 0 < day <= monthDays(y,m)
    function isValidDate(
        uint256 y,
        uint256 m,
        uint256 d
    ) internal pure returns (bool valid) {
        uint256 md = monthDays(y, m);
        /// @solidity memory-safe-assembly
        assembly {
            valid := iszero(or(or(or(or(or(lt(y, 1970),gt(y,317027972476686572410305440929486321699336700043506886628630523577932824464)),iszero(m)), gt(m, 12)), iszero(d)), gt(d, md)))
        }
    }

    /// @dev Returns timestamp If the given nth weekday in month of year is possible else zero
    /// @dev wd range is must be [0,6] where 0-Monday, 1-Tuesday,...., 6-Sunday
    /// (Example) 2022-2 3th friday (getNthDayInMonthOfYear(2022,2,3,5))
    function getNthDayInMonthOfYear(
        uint256 y,
        uint256 m,
        uint256 n,
        uint256 wd
    ) internal pure returns (uint256 t) {
        bool z = isValidDate(y,m,1);
        uint256 d = daysFromDate(y,m,1);
        assembly {
            if iszero(iszero(z)) {
                // weekday of 01-mm-yyyy w0 = (d + 3) % 7
                // weekday diffrence x = (wd - w0) , x = x <= 6 ? x : x + 7
                let diff := sub(wd, mod(add(d, 3), 7))
                // date = x + (n-1)*7 + 1
                let date := add(add(mul(sub(n, 1), 7), 1), add(diff, mul(gt(diff, 6), 7)))
                // timestamp = 86400 * ((date - 1) + d)
                t := mul(PER_DAY_SECOND, add(sub(date, 1), d))
            }
        }
    }

    /// @dev Returns Next Weekday timestamp 
    /// @notice wd range must be [0,6] (where 0-Monday, 1-Tuesday,...., 6-Sunday) else undefined behaviour 
    function getNextWeekDay(uint256 t, uint256 wd) internal pure returns(uint256 _timestamp) {
        assembly {
            // days = t / 86400;
            let day := div(t,86400)
            // weekday of 01-mm-yyyy w0 = (d + 3) % 7
            // weekday diffrence x = (wd - w0) , x = x <= 6 ? x : x + 7
            let diff := sub(wd, mod(add(day,3), 7))
            // d := gt(diff,6) || iszero(diff) ? diff + 7 : diff
            let d := add(day,add(diff , mul(or(gt(diff,6),iszero(diff)),7)))
            _timestamp := mul(d,86400)
        }
    }
}

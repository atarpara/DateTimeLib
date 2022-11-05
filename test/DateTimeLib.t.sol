// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../test/utils/TestPlus.sol";
import "src/DateTimeLib.sol";

contract DateTimeLibTest is TestPlus {
    function testDaysFromDate() public {
        assertEq(DateTimeLib.daysFromDate(1970,1,1),0);
        assertEq(DateTimeLib.daysFromDate(1970,1,2),1);
        assertEq(DateTimeLib.daysFromDate(1970,2,1),31);
        assertEq(DateTimeLib.daysFromDate(1970,3,1),59);
        assertEq(DateTimeLib.daysFromDate(1970,4,1),90);
        assertEq(DateTimeLib.daysFromDate(1970,5,1),120);
        assertEq(DateTimeLib.daysFromDate(1970,6,1),151);
        assertEq(DateTimeLib.daysFromDate(1970,7,1),181);
        assertEq(DateTimeLib.daysFromDate(1970,8,1),212);
        assertEq(DateTimeLib.daysFromDate(1970,9,1),243);
        assertEq(DateTimeLib.daysFromDate(1970,10,1),273);
        assertEq(DateTimeLib.daysFromDate(1970,11,1),304);
        assertEq(DateTimeLib.daysFromDate(1970,12,1),334);
        assertEq(DateTimeLib.daysFromDate(1970,12,31),364);
        assertEq(DateTimeLib.daysFromDate(1971,1,1),365);
        assertEq(DateTimeLib.daysFromDate(1980,11,3),3959);
        assertEq(DateTimeLib.daysFromDate(2000,3,1),11017);
        assertEq(DateTimeLib.daysFromDate(2355,12,31),140982);
        assertEq(DateTimeLib.daysFromDate(99999,12,31),35804721);
        assertEq(DateTimeLib.daysFromDate(100000,12,31),35805087);
    }

    function testDaysToDate() public {
        uint256 year;
        uint256 month;
        uint256 day;
        (year,month,day) = DateTimeLib.daysToDate(0);
        assertTrue(year==1970 && month == 1 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(31);
        assertTrue(year==1970 && month == 2 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(59);
        assertTrue(year==1970 && month == 3 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(90);
        assertTrue(year==1970 && month == 4 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(120);
        assertTrue(year==1970 && month == 5 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(151);
        assertTrue(year==1970 && month == 6 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(181);
        assertTrue(year==1970 && month == 7 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(212);
        assertTrue(year==1970 && month == 8 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(243);
        assertTrue(year==1970 && month == 9 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(273);
        assertTrue(year==1970 && month == 10 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(304);
        assertTrue(year==1970 && month == 11 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(334);
        assertTrue(year==1970 && month == 12 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(365);
        assertTrue(year==1971 && month == 1 && day ==1);
        (year,month,day) = DateTimeLib.daysToDate(10987);
        assertTrue(year==2000 && month == 1 && day == 31);
        (year,month,day) = DateTimeLib.daysToDate(18321);
        assertTrue(year==2020 && month == 2 && day == 29);
        (year,month,day) = DateTimeLib.daysToDate(156468);
        assertTrue(year==2398 && month == 5 && day == 25);        
        (year,month,day) = DateTimeLib.daysToDate(35805087);
        assertTrue(year==100000 && month == 12 && day == 31);
    }

    function testFuzzDaysToDate(uint256 z) public {
        (uint256 y, uint256 m, uint256 d) = DateTimeLib.daysToDate(z);
        uint256 day = DateTimeLib.daysFromDate(y,m,d);
        assertEq(z,day);
    }

    function testFuzzDaysFromDate(uint256 _y, uint256 _m, uint256 _d) public {
        // MAX POSSIBLE DAY = 115792089237316195423570985008687907853269984665640564039457584007913128920467
        // MAX DATE = 317027972476686572410305440929486321699336700043506886628630523577932824465 - 12 - 03
        // _y = bound(_y,1970,317027972476686572410305440929486321699336700043506886628630523577932824464);
        vm.assume(DateTimeLib.isValidDate(_y,_m,_d));
        uint256 day = DateTimeLib.daysFromDate(_y,_m,_d);
        (uint256 y, uint256 m, uint256 d) = DateTimeLib.daysToDate(day);
        assertTrue(_y == y && _m == m && _d == d);
    }

    function testIsLeapYear() public {
        assertTrue(DateTimeLib.isLeapYear(2000));
        assertTrue(DateTimeLib.isLeapYear(2024));
        assertTrue(DateTimeLib.isLeapYear(2048));
        assertTrue(DateTimeLib.isLeapYear(2072));
        assertTrue(DateTimeLib.isLeapYear(2104));
        assertTrue(DateTimeLib.isLeapYear(2128));
        assertTrue(DateTimeLib.isLeapYear(10032));
        assertTrue(DateTimeLib.isLeapYear(10124));
        assertTrue(DateTimeLib.isLeapYear(10296));
        assertTrue(DateTimeLib.isLeapYear(10400));
        assertTrue(DateTimeLib.isLeapYear(10916));
    }

    function testFuzzIsLeapYear(uint256 y) public {
        if ( (y % 4 == 0) && ( y % 100 != 0 || y % 400 == 0)) {
            assertTrue(DateTimeLib.isLeapYear(y));
        }else{
            assertFalse(DateTimeLib.isLeapYear(y));
        }
    }

    function testMonthDays() public {
        assertEq(DateTimeLib.monthDays(2022,1),31);
        assertEq(DateTimeLib.monthDays(2022,2),28);
        assertEq(DateTimeLib.monthDays(2022,3),31);
        assertEq(DateTimeLib.monthDays(2022,4),30);
        assertEq(DateTimeLib.monthDays(2022,5),31);
        assertEq(DateTimeLib.monthDays(2022,6),30);
        assertEq(DateTimeLib.monthDays(2022,7),31);
        assertEq(DateTimeLib.monthDays(2022,8),31);
        assertEq(DateTimeLib.monthDays(2022,9),30);
        assertEq(DateTimeLib.monthDays(2022,10),31);
        assertEq(DateTimeLib.monthDays(2022,11),30);
        assertEq(DateTimeLib.monthDays(2022,12),31);
        assertEq(DateTimeLib.monthDays(2024,1),31);
        assertEq(DateTimeLib.monthDays(2024,2),29);
        assertEq(DateTimeLib.monthDays(1900,2),28);
    }
    function testFuzzMonthDays(uint256 y, uint256 m) public {
        m = _bound(m,1,12);
        if (DateTimeLib.isLeapYear(y) && m == 2) {
            assertEq(DateTimeLib.monthDays(y,m),29);
        } else if ( m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12) {
            assertEq(DateTimeLib.monthDays(y,m),31);
        } else if ( m == 2) {
            assertEq(DateTimeLib.monthDays(y,m),28);
        }else {
            assertEq(DateTimeLib.monthDays(y,m),30);
        }
    }
    
    function testGetWeekDay() public {
        assertEq(DateTimeLib.getWeekDay(1),3);
        assertEq(DateTimeLib.getWeekDay(86400),4);
        assertEq(DateTimeLib.getWeekDay(86401),4);
        assertEq(DateTimeLib.getWeekDay(172800),5);
        assertEq(DateTimeLib.getWeekDay(259200),6);
        assertEq(DateTimeLib.getWeekDay(345600),0);
        assertEq(DateTimeLib.getWeekDay(432000),1);
        assertEq(DateTimeLib.getWeekDay(518400),2);
    }

    function testFuzzGetWeekDay() public {
        uint256 t = 0;
        uint256 wd = 3;
        unchecked
        {
        for (uint256 i = 0; i < 1000; ++i)
        {
            assertEq(DateTimeLib.getWeekDay(t),wd);
            t += 86400;
            wd = (wd + 1) % 7;
        }
        }
    }

    function testIsValidDateTrue() public {
        assertTrue(DateTimeLib.isValidDate(1970,1,1));
        assertTrue(DateTimeLib.isValidDate(1971,5,31));
        assertTrue(DateTimeLib.isValidDate(1971,6,30));
        assertTrue(DateTimeLib.isValidDate(1971,12,31));
        assertTrue(DateTimeLib.isValidDate(1972,2,28));
        assertTrue(DateTimeLib.isValidDate(1972,4,30));
        assertTrue(DateTimeLib.isValidDate(1972,5,31));
        assertTrue(DateTimeLib.isValidDate(2000,2,29));
    }

    function testIsValidDateFalse() public {
        assertFalse(DateTimeLib.isValidDate(0,0,0));
        assertFalse(DateTimeLib.isValidDate(1970,0,0));
        assertFalse(DateTimeLib.isValidDate(1970,1,0));
        assertFalse(DateTimeLib.isValidDate(1969,1,1));
        assertFalse(DateTimeLib.isValidDate(1800,1,1));
        assertFalse(DateTimeLib.isValidDate(317027972476686572410305440929486321699336700043506886628630523577932824465,1,1));
        assertFalse(DateTimeLib.isValidDate(1970,13,1));
        assertFalse(DateTimeLib.isValidDate(1700,13,1));
        assertFalse(DateTimeLib.isValidDate(1970,15,32));
        assertFalse(DateTimeLib.isValidDate(1970,1,32));
        assertFalse(DateTimeLib.isValidDate(1970,13,1));
        assertFalse(DateTimeLib.isValidDate(1879,1,1));
        assertFalse(DateTimeLib.isValidDate(1970,4,31));
        assertFalse(DateTimeLib.isValidDate(1970,6,31));
        assertFalse(DateTimeLib.isValidDate(1970,7,32));
        assertFalse(DateTimeLib.isValidDate(2000,2,30));
    }

    function testFuzzIsValidDate(uint256 y, uint256 m, uint256 d) public {
        if( y > 1969 && y < 317027972476686572410305440929486321699336700043506886628630523577932824464) {
            if ( m > 0 && m < 13 && d > 0 && d < DateTimeLib.monthDays(y,m)) {
                assertTrue(DateTimeLib.isValidDate(y,m,d));
            }
        }
    }

    function testGetNthDayInMonthOfYear() public {
        
    }

}

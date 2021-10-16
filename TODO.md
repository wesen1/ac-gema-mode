ac-gema-mode
============

New Features
------------

###  Add menu to configure timestamp format

Steps:

- [ ] Add a timestamp format string parser
- [ ] Add a menu to configure the timestamp format

Format specifiers:

* Date:
  * Day Number with pad zeros
  * Month Number with pad zeros
  * Year Number
  * Day Name
  * Month Name
* Time:
  * Hours with pad zeros
  * Minutes with pad zeros
  * Seconds with pad zeros


### Make color theme configurable

* Add a menu to select a color theme
* Rename colors.cfg to colors/default.cfg
* Maybe add another color theme to choose from


Bug Fixes
---------

* fix mapstartalways not working when mapstartalways handler already exists (e.g. defined in respawn script)
  -> maybe afterinit needed because saved.cfg > cubescript files

* array set -> what to do if dimensionIndexes has more dimensions than the array and the array is not empty?
* array length: If no separator is given use this separator: (strrepeat (array_getMaxDimensions $arg1))
* array_lengh should return array length with max dimension

* time target: Add margin between "ms" and text input field

* Create empty map record list on map start but don't save it to saved.cfg yet to maybe improve performance


Ideas
-----

* Add compatibility for version 1.0.0

* Add option to auto select best weapon in weapon map records menu

* Autochoose best record team on mapstart

* Add general menu max width

* docs: Add "persistidents 0;" to top

* Track which menus were opened in which order to reopen them on translation/color rebuild

* Try to find way to auto reset flag offline

```
  checkinit onFlag [

    // Test whether auto flag reset is possible
    if (&& $gematoggle (|| (= $arg1 1) (= $arg1 2))) [
      echo "Flag was lost or dropped";
      action 7;
    ];

  ]
```

* Filter maps list by gema maps -> not possible


Quality
-------

* Find unused strings
* Find unused colors
* Find unused functions
* Find unused variables


### Tests ###

* Add unit tests (only for developers, releases don't contain the test directories and file)


Distribution
------------

### Dist ###

* Replaces $<constant> with the value of the constant for performance boosts

* Add option to minify code (Replace variable names by auto generated names)

* Add persistidents 1 at start of each file


Code
----

* Add :: before each variable name to "hide" them ingame
* Make variable and function names more specific (since all variables and functions in the whole game share the same namespace)
  -> "::" + <project title> + "_" + <function name> + "_" + <alias name>
  => Should be done by dist script, mode A = dist, mode B = dist.min


Other
-----

* Find best file mode
* Find hardcoded colors: grep -r "(c [^$]" ac-gema-mode

[![Maven Central](https://img.shields.io/maven-central/v/io.github.dalgarins/android-spatialite)](https://central.sonatype.com/artifact/io.github.dalgarins/android-spatialite)
[![JitPack](https://jitpack.io/v/com.github.dalgarins/android-spatialite.svg)](https://jitpack.io/#com.github.dalgarins/android-spatialite)

# android-spatialite 

this is a fork from [android-spatialite](https://github.com/sevar83/android-spatialite).

## WHAT IS THIS?
- The [Spatialite](https://www.gaia-gis.it/gaia-sins/) database ported for *Android*
- 100% offline, portable and self-contained as *SQLite*.

## WHEN DO I NEED IT?
- When you need deployment, collecting, processing and fast querying of small to huge amounts of geometry data (points, polylines, polygons, multipolygons, etc.) on Android devices.
- When you want to be 100% independent from any server/cloud backend.

## GETTING STARTED

If you know basic *SQLite*, there's almost nothing to learn. The API is 99% the same as the Android *SQLite* API (as of API level 15). The main difference is the packaging. Use `org.spatialite.database.XYZ` instead of `android.database.sqlite.XYZ` and `org.spatialite.XYZ` instead of `android.database.XYZ`. Same applies to the other classes - all platform `SQLiteXYZ` classes have their *Spatialite* versions.

### Gradle

> [!IMPORTANT]
> Starting with **2.2.3** the library is published to **Maven Central** under the new
> group id `io.github.dalgarins`. This is the recommended way to use it.
>
> For now, every release is **also** available on **JitPack** as `com.github.dalgarins`
> (the only option for **2.2.1 and earlier**). JitPack is deprecated and will stop
> receiving new versions in a future release, so please migrate to Maven Central.

| Versions | Repository | Coordinates | Status |
|---|---|---|---|
| 2.2.3 and later | Maven Central | `io.github.dalgarins:android-spatialite` | Recommended |
| 2.2.3 and later | JitPack | `com.github.dalgarins:android-spatialite` | Deprecated, will be removed |
| 2.2.1 and earlier | JitPack | `com.github.dalgarins:android-spatialite` | Legacy |

#### Maven Central (2.2.3 and later)

Make sure `mavenCentral()` is in your repositories (it is by default in new Android projects),
then add the dependency to your module's `build.gradle`:

```
implementation 'io.github.dalgarins:android-spatialite:<LATEST_VERSION>'
```

#### JitPack (deprecated)

1) Have this in your project's `build.gradle`:

```
allprojects {
  repositories {
    ...
    maven { url "https://jitpack.io" }
  }
}
```

2) Add the following to your module's `build.gradle`:
```
implementation 'com.github.dalgarins:android-spatialite:<VERSION>'
```

#### Migrating from JitPack to Maven Central

Change the group id from `com.github.dalgarins` to `io.github.dalgarins` and use version
2.2.3 or later. The Java API (`org.spatialite.*`) is unchanged. You can remove the JitPack
repository if no other dependency needs it.

## EXAMPLE CODE
There is a very simple and useless example in the `app` module. Another example is the [SpatiAtlas](https://github.com/sevar83/SpatiAtlas) experiment.

## HOW IT WORKS?
Works the same way as the platform *SQLite*. It's accessible through `Java/JNI` wrappers around the *Spatialite* C library. 
The *Spatialite* wrappers were derived and adapted from the platform *SQLite* wrappers (the standard Android SQLite API).

## Other FAQ

### What is *Spatialite*?
Simply: *Spatialite* = *SQLite* + advanced geospatial support.<br>
*Spatialite* is a geospatial extension to *SQLite*. It is a set of few libraries written in C to extend *SQLite* with geometry data types and many [SQL functions](http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html) above geometry data. For more info: https://www.gaia-gis.it/gaia-sins/

### Is there a list of all supported Spatialite functions?
Yes - http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.4.0.html

### Does it use JDBC?
No. It uses cursors - the suggested lightweight approach to access SQL used in the Android platform instead of the heavier JDBC.

### 64-bit architectures supported?

Yes. It builds for `arm64-v8a` and `x86_64`. `mips64` is not tested.

### Reducing the APK size. 

This library is distributed as multi-architecture AAR file. 
By default Gradle will produce a universal APK including the native .so libraries compiled for all supported CPU architectures. Usually that's unacceptable for large libraries like this.
But that's easily fixed by using Gradle's "ABI splits" feature. The following gradle code will produce a separate APK per each architecture. The APK size is reduced few times.
```
android {
    splits {
        abi {
            enable true
                reset()
                include "armeabi-v7a", "arm64-v8a", "x86", "x86_64"
            }
        }
    }
}
```

### What libraries are packaged currently?

| Library | Version | Source |
|---|---|---|
| SQLite | 3.49.1 | copied (amalgamation) |
| Spatialite | 4.3.0a | copied |
| GEOS | 3.4.2 | submodule — [libgeos/geos](https://github.com/libgeos/geos) |
| Proj4 | 4.8.0+ (commit `b958c66`) | submodule — [OSGeo/PROJ](https://github.com/OSGeo/PROJ) |
| iconv | 1.13.1 | submodule — [GNU libiconv](https://git.savannah.gnu.org/git/libiconv.git) |
| xml2 | 2.15.2 | submodule — [GNOME/libxml2](https://gitlab.gnome.org/GNOME/libxml2) |
| freexl | 1.0.2 | copied (upstream uses Fossil, not Git) |
| lwgeom | 2.2.x (commit `21df9ef8`) | copied (PostGIS `stable-2.2`) |

*Copied* means the sources live in this repository. *Submodule* means they are fetched from
upstream, pinned to the commit recorded here — see [BUILDING FROM SOURCE](#building-from-source).

## REQUIREMENTS
Min SDK 23

## BUILDING FROM SOURCE

Some of the native dependencies are Git submodules, so a plain `git clone` leaves their
directories empty and the NDK build fails with missing headers.

Clone the repository with them:
```
git clone --recurse-submodules https://github.com/dalgarins/android-spatialite.git
```

If you already cloned it without them:
```
git submodule update --init --recursive
```

Then build:
```
./gradlew :lib:assembleRelease
```

Which dependencies are submodules and which are copied into the repository is listed in
[What libraries are packaged currently?](#what-libraries-are-packaged-currently).

Each of those modules has a `generated/` directory next to its submodule holding the headers
that `./configure` produces (`config.h` and friends). They are not part of the upstream
repositories, so they are versioned here and must be updated whenever the submodule is moved
to a new release.

Note that `git checkout` and `git switch` do not update submodule working trees. After
changing branches, run `git submodule update --recursive` to keep the sources in sync with
the commit they are pinned to.

## MIGRATION TO 2.0+

1. Remove calls to `SQLiteDatabase.loadLibs()`. Now it is automatically done.
2. Replace all occasions of `import org.spatialite.Cursor;` with `import android.database.Cursor;`
3. Replace all occasions of `import org.spatialite.database.SQLite***Exception;` with `import android.database.sqlite.SQLite***Exception;`

## CHANGES

### 2.2.3 (minSdkVersion 23)
- Published to Maven Central as `io.github.dalgarins:android-spatialite`. Still available on JitPack as `com.github.dalgarins:android-spatialite` (deprecated, will be removed in a future release)
- Native dependencies (PROJ, GEOS, iconv, libxml2) are now git submodules pinned to upstream releases
- Upgrade xml2 to 2.15.2
- Remove lzma dependency
- Link the C++ runtime statically (`c++_static`): `libc++_shared.so` is no longer shipped

### 2.2.1 (minSdkVersion 23)
- Upgrade SQLite to 3.49.1
- Upgrade xml2 to 2.13.6

### 2.2.0 (minSdkVersion 23)
- Upgrade minSdkVersion to 23
- Upgrade targetSdkVersion to 36
- Support android size 16kb

### 2.1.2-ndk-r23c (minSdkVersion 23)
- Upgrade minSdkVersion to 23
- Upgrade targetSdkVersion to 34
- Fix compatibility with mapbox v11 min ndk version 23

### 2.1.2-ndk23-alpha (minSdkVersion 23)
- Upgrade minSdkVersion to 23
- Upgrade targetSdkVersion to 34
- Fix compatibility with mapbox min ndk version 23

### 2.1.2-alpha (minSdkVersion 21)
- Upgrade minSdkVersion to 21
- Upgrade targetSdkVersion to 34

### 2.1.1-alpha (minSdkVersion 16)
- Enable SQLite DBSTAT virtual table

### 2.1.0-alpha
- Added support for lwgeom functions

### 2.0.1
- Migrated to AndroidX
- Fixed native crash [#4](https://github.com/sevar83/android-spatialite/issues/4)

### 2.0.0
- Now using the [Requery.io SQLite wrapper](https://github.com/requery/sqlite-android/) instead of SQLCipher's. This results to:
- Android Nougat (25+) supported. The native code no more links to private NDK libraries exception and warning messages similar to `UnsatisfiedLinkError: dlopen failed: library "libandroid_runtime.so" not found` should be no more. For more details: https://developer.android.com/about/versions/nougat/android-7.0-changes.html#ndk;
- Much cleaner codebase derived from a much newer and more mature AOSP SQLite wrapper snapshot;
- Now possible to build with the latest NDK (tested on R14);
- Switched to CLang as the default NDK toolchain;
- 64-bit build targets (arm64-v8a, x86_64);
- `SQLiteDatabase.loadLibs()` initialization call is not required anymore;
- Removed `org.spatialite.Cursor` interface. Used 'android.database.sqlite.Cursor' instead.
- Removed the `SQLiteXyzException` classes. Their AOSP originals are used instead;
- Dropped support for Android localized collation. SQL statements with "COLLATE LOCALIZED" will cause error. This is necessary to reduce the library size and ensure N compatibility;
- Updated SQLite to 3.15.1;
- Updated lzma to 5.2.1;
- Updated FreeXL to 1.0.2;

## Proguard configuration

Add this line to your proguard rules file.

```properties
-keep class org.spatialite.database.** { *; }
-keep class org.spatialite.** { *; }
```

Without these rules, you may encounter errors like:
```
Throwing new exception 'no "I" field "numArgs" in class "Lorg/spatialite/database/SQLiteCustomFunction;"
```

## CREDITS
The main ideas used here were borrowed from:
- https://github.com/requery/sqlite-android
- https://github.com/sqlcipher/android-database-sqlcipher
- https://github.com/illarionov/android-sqlcipher-spatialite

## SUPPORT

If you like this library, please consider...

<a href="https://www.buymeacoffee.com/dalgarins" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

## SPONSORS

Thanks to our sponsors for supporting this project!

- [![Tybion](https://github.com/Tybion.png?size=60)](https://github.com/Tybion) [@Tybion](https://github.com/Tybion)

*Become a sponsor! Support via [Buy Me a Coffee](https://www.buymeacoffee.com/dalgarins) or [GitHub Sponsors](https://github.com/sponsors/dalgarins).*

## KNOWN PROJECTS USING THIS LIBRARY

- [EVMap - EV chargers](https://play.google.com/store/apps/details?id=net.vonforst.evmap)
- [Australian Geology Travel Maps](https://play.google.com/store/apps/details?id=solutions.trilobite.ausgeology)

## LICENSE
Apache License 2.0

Job Control Mod v1.0
By Leslie Krause

Job Control offers a more flexible alternative to the builtin minetest.after function.

 * Jobs can be cancelled, extended, or restarted via object-specific methods.
 * Jobs can be repeated at a constant interval when the callback returns true.
 * The elapsed, remaining, and overrun time of jobs can be readily calculated.
 
There are two ways to install Job Control: either as a typical mod within the directory
structure of your game or by replacing the file 'builtin/common/after.lua' (be sure to
create a backup of the original file). The latter has the advantage that it eliminates
the small degree of overhead from an extraneous globalstep running in the background.

A job can be scheduled in the typical fashion, thus ensuring backward compatibility:

 o minetest.after( wait, func, ... )
   Executes the callback after a timeout with optional parameters. The newly constructed 
   Job object is returned.

Each job object has access to the following methods and properties:

 * Job::wait
   The timeout passed to the constructor. This property is immutable.

 * Job::expiry
   The expiration timestamp of the job. This property is immutable.

 * Job::origin
   The name of the mod that created the job. This property is immutable.
   
 * Job::cancel( )
   Removes the job from the pending job queue. The callback will no longer be executed.

 * Job::extend( new_wait )
   Reschedules the job with an additional timeout, beyond the expiration timestamp.

 * Job::restart( wait )
   Reschedules the job with a different timeout.

 * Job::get_remain( )
   Returns the remaining time period of the job. From this, it is possible to calculate 
   the elapsed and overrun time periods as well.[/list]

As mentioned earlier, it is also possible to cycle a job simply by returning true in the 
callback. This can be useful for tasks that must be performed at regular intervals, such 
as writing data files to disk. Bear in mind, however, that this isn't a replacement for
an actual synchronized timer since the callback execution itself can incur a marginal 
delay during each iteration.


Repository
----------------------

Browse source code:
  https://bitbucket.org/sorcerykid/cronjob

Download archive:
  https://bitbucket.org/sorcerykid/cronjob/get/master.zip
  https://bitbucket.org/sorcerykid/cronjob/get/master.tar.gz

Source Code License
----------------------

The MIT License (MIT)

Copyright (c) 2020, Leslie Krause (leslie@searstower.org)

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

For more details:
https://opensource.org/licenses/MIT

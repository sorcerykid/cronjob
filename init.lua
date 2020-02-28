--------------------------------------------------------
-- Minetest :: Job Control Mod v1.0a (cronjob)
--
-- See README.txt for licensing and release notes.
-- Copyright (c) 2016-2020, Leslie E. Krause
--
-- ./games/minetest_game/mods/cronjob/init.lua
--------------------------------------------------------

local get_us_time = core.get_us_time
local active_jobs = { }
local ctime = get_us_time( ) / 1000000
local next_expiry = nil

core.register_globalstep( function( )
	ctime = get_us_time( ) / 1000000

	if next_expiry and ctime >= next_expiry then
		next_expiry = nil

		-- iterate backwards so that we miss any new timers added within
		-- a timer callback to avoid recursion.
		for i = #active_jobs, 1, -1 do
			local job = active_jobs[ i ]

			if job.expiry <= ctime then
				core.set_last_run_mod( job.origin )
				if job.func( unpack( job.args ) ) then
					job.expiry = ctime + job.wait
					if not next_expiry or job.expiry < next_expiry then
						next_expiry = job.expiry
					end
				else
					active_jobs[ i ] = active_jobs[ #active_jobs ]
					active_jobs[ #active_jobs ] = nil
				end
			elseif not next_expiry or job.expiry < next_expiry then
				next_expiry = job.expiry
			end
		end
	end
end )

minetest.after = function ( wait, func, ... )
	assert( tonumber( wait ) and type( func ) == "function", "Invalid core.after invocation" )

	local job_def = { }

	job_def.func = func
	job_def.args = { ... }
	job_def.wait = wait
	job_def.expiry = ctime + wait
	job_def.origin = core.get_last_run_mod( )

	job_def.cancel = function ( )
		next_expiry = nil

		for i = #active_jobs, 1, -1 do
			local job = active_jobs[ i ]
			if job == job_def then
				-- switch this slot with last slot and remove
				-- last slot for efficiency
				active_jobs[ i ] = active_jobs[ #active_jobs ]
				active_jobs[ #active_jobs ] = nil
			elseif not next_expiry or job.expiry < next_expiry then
				next_expiry = job.expiry
			end
		end
	end

	job_def.extend = function ( new_wait )
		job_def.expiry = job_def.expiry + ( new_wait or wait )
		for i = #active_jobs, 1, -1 do
			next_expiry = math.min( next_expiry, active_jobs[ i ].expiry )
		end
	end
	job_def.restart = function ( new_wait )
		job_def.expiry = ctime + ( new_wait or wait )
		for i = #active_jobs, 1, -1 do
			next_expiry = math.min( next_expiry, active_jobs[ i ].expiry )
		end
	end
	job_def.get_remain = function ( )
		return ctime - job_def.expiry
	end

	if not next_expiry or job_def.expiry < next_expiry then
		next_expiry = job_def.expiry
	end

	active_jobs[ #active_jobs + 1 ] = job_def

	return job_def
end

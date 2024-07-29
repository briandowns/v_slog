module s_logger

import log
import maps
import os
import time
import x.json2

type Level = log.Level
type Field = map[string]json2.Any

// name returns the string representation of the
// the log level.
fn (l Level) name() string {
	return match l {
		.disabled { '' }
		.info { 'info' }
		.warn { 'warn' }
		.error { 'error' }
		.debug { 'debug' }
		.fatal { 'fatal' }
		else { '' }
	}
}

// Logger maintains the state of the logger.
@[noinit]
struct Logger {
mut:
	log_to_console bool
	file           os.File
	level          Level
}

// Logger.new creates a new value with a default
// level of "info" set.
pub fn Logger.new() Logger {
	return Logger{
		log_to_console: true
		level: .info
	}
}

// get_level returns the current level for the logger.
pub fn (l &Logger) get_level() Level {
	return l.level
}

// set_level sets the given level for the logger.
pub fn (mut l Logger) set_level(level Level) {
	l.level = level
}

// set_to_console sets the given value for the logger.
pub fn (mut l Logger) set_log_to_console(val bool) {
	l.log_to_console = val
}

// set_file sets the given file for the logger.
pub fn (mut l Logger) set_file(file string) ! {
	if l.file.is_opened {
		l.file.close()
	}

	if !os.exists(file) {
		l.file = os.open_file(file, 'a')!
	} else {
		l.file = os.open_append(file)!
	}

	return
}

// new_field takes a key and a value and returns a map holding
// those values.
pub fn new_field(key string, value json2.Any) Field {
	mut f := map[string]json2.Any{}
	f[key] = value
	return f
}

// info logs the given message and optional data to the
// configured output at level info.
pub fn (mut l Logger) info(msg string, fields ...Field) !int {
	return l.raw_log(msg, .info, ...fields)!
}

// warn logs the given message and optional data to the
// configured output at level warn.
pub fn (mut l Logger) warn(msg string, fields ...Field) !int {
	return l.raw_log(msg, .warn, ...fields)!
}

// error logs the given message and optional data to the
// configured output at level error.
pub fn (mut l Logger) error(msg string, fields ...Field) !int {
	return l.raw_log(msg, .error, ...fields)!
}

// debug logs the given message and optional data to the
// configured output at level debug.
pub fn (mut l Logger) debug(msg string, fields ...Field) !int {
	return l.raw_log(msg, .debug, ...fields)!
}

// debug logs the given message and optional data to the
// configured output.
pub fn (mut l Logger) fatal(msg string, fields ...Field) !int {
	return l.raw_log(msg, .fatal, ...fields)!
}

// log logs the given message and optional data to the
// configured output.
pub fn (mut l Logger) log(msg string, fields ...Field) !int {
	return l.raw_log(msg, l.level, ...fields)!
}

pub fn (mut l Logger) raw_log(msg string, level Level, fields ...Field) !int {
	mut out := map[string]json2.Any{}
	out['time'] = time.now().unix()
	out['level'] = level.name()
	out['msg'] = msg

	if fields.len > 0 {
		for f in fields {
			maps.merge_in_place(mut out, f)
		}
	}

	out_len := out.str().len

	if l.file.is_opened {
		l.file.write_string(out.str()+"\n")!
	}
	if l.log_to_console {
		println(out.str())
	}

	if l.level == .fatal {
		exit(1)
	}

	return out_len
}

module s_logger

fn test_level_name() {
	assert Level.info.name() == 'info'
	assert Level.debug.name() == 'debug'
	assert Level.warn.name() == 'warn'
	assert Level.error.name() == 'error'
	assert Level.fatal.name() == 'fatal'
	assert Level.disabled.name() == ''
}

fn test_get_level() {
	logger := Logger.new()
	assert logger.get_level() == .info
}

fn test_set_level() {
	mut logger := Logger.new()
	logger.set_level(.warn)
	assert logger.get_level() == .warn
}

fn test_info_to_stdout() {
	mut logger := Logger.new()
	out_len := logger.info('blah', new_field('key2', 'value2'))!
	assert out_len == 63
}

fn test_warn_to_stdout() {
	mut logger := Logger.new()
	out_len := logger.warn('blah', new_field('key3', 'value3'))!
	assert out_len == 63
}

fn test_error_to_stdout() {
	mut logger := Logger.new()
	out_len := logger.error('blah', new_field('key4', 'value4'))!
	assert out_len == 64
}

fn test_debug_to_stdout() {
	mut logger := Logger.new()
	out_len := logger.debug('blah', new_field('key5', 'value5'))!
	assert out_len == 64
}


fn test_log_to_stdout() {
	mut logger := Logger.new()
	out_len := logger.log('blah', new_field('key2', 'value2'))!
	assert out_len == 63
}

fn test_info_to_log_file() {
	mut logger := Logger.new()
	logger.set_log_to_console(false)
	logger.set_file('log_file')!
	out_len := logger.info('blah', new_field('key2', 'value2'))!
	assert out_len == 63
}

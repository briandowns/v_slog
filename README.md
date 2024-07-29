# s_logger

Structured logger (JSON) for the V programming language.

```v
import s_logger

fn main() {
	mut logger := Logger.new()

	println(logger.get_level())
	logger.set_level(.warn)
	println(logger.get_level())

	logger.info('here', new_field('key', 'value'))
	logger.warn('here', new_field('key', 'value'), new_field('key2', 'value2'))
	logger.error('here', new_field('int', 100))

	logger.log('now here')
}
```

## Contact

Brian Downs [@bdowns328](http://twitter.com/bdowns328)

## License

v_slog source code is available under the BSD 3 Clause [License](/LICENSE).

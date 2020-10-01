# frozen_string_literal: true
Env['help', false]
Env['...print help', 'h']

Env['verbose', false]
Env['...verbosity level', 'v']

Env['search', false]
Env['...search remote packages', 's']

Env['remove', false]
Env['...remove package', 'r']

Env['list', false]
Env['...list local packages', 'l']

Env['info', false]
Env['...print remote package info', 'i']

Env['upgrade', false]
Env['...upgrade imp!', 'u']

Env['tui', false]
Env['...force text user interface']

# Env["depend", "", ["ALL"]]
# Env["...skip given dependency", "d"]

Env['local', "#$git/local", :same]
Env['...local imp packages dir']

Env['temp',  Env['local'] + '/.temp', :same]
Env['...temporary dir']

Env['keep', false]
Env['...discourage package export']

Env['clean', '', '']
Env['...clean install']

Env['env', false]
Env['...export imp env']

Env['todo', '', '']
Env['...todo, but option format']

Env['plugin', false]
Env['...show plugins']

Env['debug', false]
Env['...debug mode']

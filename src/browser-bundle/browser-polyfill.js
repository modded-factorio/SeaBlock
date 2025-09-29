// Enhanced browser polyfill for VitePress
// This must run before any other code that might need Node.js globals

if (typeof window !== 'undefined') {
  // Mock Node.js environment that VitePress expects
  if (typeof global === 'undefined') {
    window.global = window
  }

  // Enhanced process object
  if (typeof process === 'undefined') {
    window.process = {
      cwd: () => '/',
      env: { NODE_ENV: 'development' },
      platform: 'browser',
      version: '18.0.0',
      versions: { node: '18.0.0' },
      nextTick: fn => setTimeout(fn, 0),
      browser: true,
      argv: [],
      pid: 1,
      title: 'browser',
      arch: 'x64',
      exit: () => {},
      kill: () => {},
      on: () => {},
      off: () => {},
      emit: () => {}
    }
  }

  // Enhanced path module
  if (typeof path === 'undefined') {
    window.path = {
      join: (...args) => args.filter(Boolean).join('/').replace(/\/+/g, '/'),
      resolve: (...args) => '/' + args.filter(Boolean).join('/').replace(/\/+/g, '/'),
      dirname: path => path.split('/').slice(0, -1).join('/') || '/',
      basename: path => path.split('/').pop() || '',
      extname: path => {
        const parts = path.split('.')
        return parts.length > 1 ? '.' + parts.pop() : ''
      },
      sep: '/',
      delimiter: ':',
      posix: {},
      win32: {},
      normalize: path => path.replace(/\/+/g, '/'),
      relative: (from, to) => to,
      isAbsolute: path => path.startsWith('/'),
      format: pathObject => pathObject.dir + '/' + pathObject.base
    }
  }

  // Enhanced fs module for VitePress
  if (typeof fs === 'undefined') {
    window.fs = {
      readFileSync: (path, encoding) => {
        console.warn(`fs.readFileSync called for ${path} - returning empty string`)
        return ''
      },
      writeFileSync: (path, data) => {
        console.warn(`fs.writeFileSync called for ${path} - no-op in browser`)
      },
      existsSync: path => {
        console.warn(`fs.existsSync called for ${path} - returning true`)
        return true
      },
      statSync: path => ({
        isFile: () => true,
        isDirectory: () => false,
        isSymbolicLink: () => false,
        size: 0,
        mtime: new Date(),
        atime: new Date(),
        ctime: new Date()
      }),
      readdirSync: path => {
        console.warn(`fs.readdirSync called for ${path} - returning empty array`)
        return []
      },
      mkdirSync: path => {
        console.warn(`fs.mkdirSync called for ${path} - no-op in browser`)
      },
      promises: {
        readFile: async path => '',
        writeFile: async (path, data) => {},
        stat: async path => ({ isFile: () => true, isDirectory: () => false }),
        readdir: async path => [],
        mkdir: async path => {}
      }
    }
  }

  // Mock fs/promises module specifically
  if (typeof window.fsPromises === 'undefined') {
    window.fsPromises = window.fs.promises
  }
}

// Enhanced util module
if (typeof util === 'undefined') {
  window.util = {
    promisify: fn => fn,
    inspect: obj => JSON.stringify(obj, null, 2),
    format: (format, ...args) => {
      let i = 0
      return format.replace(/%[sdj%]/g, match => {
        if (match === '%%') return '%'
        if (i >= args.length) return match
        const arg = args[i++]
        switch (match) {
          case '%s':
            return String(arg)
          case '%d':
            return Number(arg)
          case '%j':
            return JSON.stringify(arg)
          default:
            return match
        }
      })
    }
  }
}

// Mock crypto module
if (typeof crypto === 'undefined' || !crypto.createHash) {
  window.crypto = window.crypto || {}
  window.crypto.createHash = algorithm => ({
    update: data => ({ digest: encoding => 'mock-hash' }),
    digest: encoding => 'mock-hash'
  })
}

// Mock os module
if (typeof os === 'undefined') {
  window.os = {
    platform: () => 'browser',
    arch: () => 'x64',
    type: () => 'Browser',
    release: () => '1.0.0',
    hostname: () => 'browser',
    homedir: () => '/',
    tmpdir: () => '/tmp',
    cpus: () => [],
    totalmem: () => 1024 * 1024 * 1024,
    freemem: () => 512 * 1024 * 1024,
    uptime: () => 0,
    loadavg: () => [0, 0, 0],
    networkInterfaces: () => ({}),
    EOL: '\n'
  }
}

// Mock url module
if (typeof url === 'undefined') {
  window.url = {
    parse: urlString => new URL(urlString),
    format: urlObject => urlObject.toString(),
    resolve: (from, to) => new URL(to, from).toString()
  }
}

// Mock events module
if (typeof events === 'undefined') {
  window.events = {
    EventEmitter: class EventEmitter {
      constructor() {
        this._events = {}
      }
      on(event, listener) {
        if (!this._events[event]) this._events[event] = []
        this._events[event].push(listener)
        return this
      }
      off(event, listener) {
        if (!this._events[event]) return this
        this._events[event] = this._events[event].filter(l => l !== listener)
        return this
      }
      emit(event, ...args) {
        if (!this._events[event]) return false
        this._events[event].forEach(listener => listener(...args))
        return true
      }
    }
  }
}

// Mock stream module
if (typeof stream === 'undefined') {
  window.stream = {
    Readable: class Readable {
      constructor(options) {
        this._readableState = { objectMode: false, highWaterMark: 16 * 1024 }
      }
      read() {
        return null
      }
      pipe(destination) {
        return destination
      }
      on(event, listener) {
        return this
      }
      once(event, listener) {
        return this
      }
      emit(event, ...args) {
        return true
      }
    },
    Writable: class Writable {
      constructor(options) {
        this._writableState = { objectMode: false, highWaterMark: 16 * 1024 }
      }
      write(chunk) {
        return true
      }
      end(chunk) {
        return this
      }
      on(event, listener) {
        return this
      }
      once(event, listener) {
        return this
      }
      emit(event, ...args) {
        return true
      }
    }
  }
}

// Mock require function for Node.js modules
if (typeof require === 'undefined') {
  window.require = module => {
    const modules = {
      path: window.path,
      fs: window.fs,
      process: window.process,
      util: window.util,
      crypto: window.crypto,
      os: window.os,
      url: window.url,
      events: window.events,
      stream: window.stream,
      'node:path': window.path,
      'node:fs': window.fs,
      'node:process': window.process,
      'node:util': window.util,
      'node:crypto': window.crypto,
      'node:os': window.os,
      'node:url': window.url,
      'node:events': window.events,
      'node:stream': window.stream,
      'node:fs/promises': window.fs.promises,
      'fs/promises': window.fs.promises
    }
    return modules[module] || {}
  }
}

console.log('✅ Enhanced browser polyfill for VitePress loaded')

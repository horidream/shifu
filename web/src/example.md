#### Ignoring a Code Block

To skip highlighting of a code block completely, use the `nohighlight` class:

    <pre><code class="nohighlight">...</code></pre>

### Node.js on the Server

The bare minimum to auto-detect the language and highlight some code.

    // load the library and ALL languages
    hljs = require('highlight.js');
    html = hljs.highlightAuto('<h1>Hello World!</h1>').value
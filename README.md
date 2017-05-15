# Roundtable

Roundtable is a design template created by The Harvard Crimson
for Commencement 2017.

## Configuration

### `config.pde`

All configuration for Roundtable is done in the `config.pde` file.
The string `roundtableTitle` should be updated to reflect the name of the
design. The data that will populate the roundtable must be stored in the
`data` array, which consists of dictionaries with the following properties:

- `name` : the individual's name
- `image` : the name of a corresponding image file which must be in the `img/` directory
- `description` : a text description of the individual

### Embed as iframe

Roundtable can be embedded as an iframe using the syntax:

```
<iframe style="overflow:hidden;" scrolling="no" width="600" height="360" src="URL_HERE"></iframe>
```

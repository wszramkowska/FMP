# FMP API Documentation

This directory contains the source pages used by Doxygen for the generated API
site. The published documentation is generated in GitHub Actions and deployed to
GitHub Pages; maintainers do not need a local Doxygen or Graphviz installation.

## Maintainer Notes

- Add Doxygen comments next to public Unreal reflection declarations in headers.
- Use `@brief`, `@param`, `@return`, `@note`, `@warning`, `@see`, and `@ingroup`
  where they add concrete behavior.
- Prefer documenting runtime behavior, Blueprint expectations, ownership, and
  networking assumptions over restating type names.
- Assign new gameplay APIs to `@ingroup FMPGameplay` or add a focused group in
  `docs/groups.dox` when the module grows.

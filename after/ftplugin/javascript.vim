set ts=2 sts=2 sw=2 et

set foldmethod=syntax foldlevel=99

" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']

// ==UserScript==
// @name         GithubEditorJump
// @namespace    https://github.com
// @version      0.1
// @description  Add ability to link to file position from PR.
// @author       DKunin
// @include      */*/*/pull/*/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    const STORAGE_KEY = 'github-jumper-projects';
    const storage = JSON.parse(localStorage.getItem(STORAGE_KEY)) || {};
    const pathName = location.pathname.split('/');
    const projectHash = pathName[2] + pathName[4];
    let projectHome = storage[projectHash] || '';

    const subMenu = document.querySelector(
        '.TableObject-item.TableObject-item--primary'
    );
    var projectPathInput = document.createElement('input');
    projectPathInput.value = projectHome;
    projectPathInput.title = projectHome;
    projectPathInput.addEventListener('change', event => {
        projectHome = event.target.value;
        projectPathInput.title = projectHome;
        storage[projectHash] = projectHome;
        localStorage.setItem(STORAGE_KEY, JSON.stringify(storage));
    });

    subMenu.appendChild(projectPathInput);

    document.addEventListener('click', (event) => {
        const { target } = event;
        if (
            target.classList
                .toString()
                .includes('js-linkable-line-number')
        ) {
            const lineNumber = target.dataset.lineNumber;
            const diffId = target.id.replace(/(L\d+$|R\d+$)/g, '');
            const parentNode = document.querySelector(
                `.file-header[data-anchor="${diffId}"]`
            );
            if (!parentNode) {
                return;
            }
            const { path } = parentNode.dataset;
            new Image().src = `http://localhost:7288/openeditor?options="${projectHome + '' + path + ':' + lineNumber}"`;
        }
    });
})();
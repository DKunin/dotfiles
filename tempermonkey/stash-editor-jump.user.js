// ==UserScript==
// @name         StashEditorJump
// @namespace    http://stash.msk.avito.ru
// @version      0.10
// @description  Add ability to link to file position from PR.
// @author       DKunin
// @include      */projects/*/repos/*/pull-requests/*
// @include      */projects/*/repos/*/commits/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    const STORAGE_KEY = 'stash-jumper-projects';
    const storage = JSON.parse(
        localStorage.getItem(STORAGE_KEY)
    ) || {};
    const pathName = location.pathname.split('/');
    const projectHash = pathName[2] + pathName[4];
    let projectHome = storage[projectHash] || '';

    const subMenu = document.querySelector('.pull-request-metadata');

    var divider = document.createElement('div');
    divider.classList.add('divider');
    divider.style = 'margin-left: 10px';
    var projectPathInput = document.createElement('input');
    projectPathInput.value = projectHome;
    projectPathInput.title = projectHome;
    projectPathInput.addEventListener('change', event => {
        projectHome = event.target.value;
        projectPathInput.title = projectHome;
        storage[projectHash] = projectHome;
        localStorage.setItem(STORAGE_KEY, JSON.stringify(storage));
    });

    subMenu.appendChild(divider);
    subMenu.appendChild(projectPathInput);

    document.addEventListener('click', function(event) {
        if (
            event.target.classList.toString() ===
            'line-number line-number-to bitbucket-gutter-marker' ||
            event.target.classList.toString() ===
            'line-number line-number-from bitbucket-gutter-marker'
        ) {
            var file = event.target.closest('.file-content');
            var lineNumber = file.querySelector(
                '.comment-container.comment-box'
            );
            if (lineNumber) {
                lineNumber = lineNumber.dataset.lineNumber;
            } else {
                lineNumber = event.target.innerText;
            }
            var path = file.querySelector('.breadcrumbs').innerText;
            new Image().src =
                'http://localhost:7288/openeditor?options="' +
                projectHome +
                path +
                ':' +
                lineNumber +
                '"';
        }
    });
})();

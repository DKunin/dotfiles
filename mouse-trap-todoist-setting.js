Mousetrap.bind('i n', function() {
    document.querySelectorAll('.filter')[0].click();
});

Mousetrap.bind('t d', function() {
    document.querySelectorAll('.filter')[2].click();
});

Mousetrap.bind('t m', function() {
    document.querySelectorAll('.filter')[3].click();
});

Mousetrap.bind('a t', function() {
    const AvitoToday = Array.from(
        document.querySelectorAll('#filters_list li')
    ).find(function(singleItem) {
        return singleItem.innerText.trim() === 'Avito Today';
    });
    if (AvitoToday) {
        AvitoToday.click();
    }
});

#!/bin/bash

ssh deploy@192.241.145.243 'cd adidas-spektre && echo $(($(cat lists/assigns | wc -l) - $(cat lists/callsdone | wc -l)))'
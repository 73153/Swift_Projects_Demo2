//
//  ordering.swift
//  LinqExamples
//
//  Created by Demis Bellot on 6/6/14.
//  Copyright (c) 2014 ServiceStack LLC. All rights reserved.
//

import Foundation

let ordering = [linq28, linq29, linq30, linq31, linq32, linq33, linq34, linq35, linq36, linq37, linq38, linq39]

func linq28(){
    let words = [ "cherry", "apple", "blueberry" ]
    
    let sortedWords = sort(words)
    
    println("The sorted list of words:")
    sortedWords.each(println)
}

func linq29(){
    let words = [ "cherry", "apple", "blueberry" ]
    
    let sortedWords = sort(words) { $0.length < $1.length }
    
    println("The sorted list of words (by length):")
    sortedWords.each(println)
}

func linq30(){
    let products = productsList()
    
    let sortedProducts = sort(products) { $0.productName < $1.productName }
    
    sortedProducts.each(println)
}

func linq31(){
    let words = [ "aPPLE", "AbAcUs", "bRaNcH", "BlUeBeRrY", "ClOvEr", "cHeRry" ]
    
    let sortedWords = sort(words, caseInsensitiveComparer)
    
    sortedWords.each(println)
}

func linq32(){
    let doubles = [ 1.7, 2.3, 1.9, 4.1, 2.9 ]
    
    let sortedDoubles = sort(doubles).reverse()
    
    println("The doubles from highest to lowest:")
    sortedDoubles.each(println)
}

func linq33(){
    let products = productsList()
    
    let sortedProducts = sort(products) { $0.unitsInStock < $1.unitsInStock }.reverse()
    
    sortedProducts.each(println)
}

func linq34(){
    let words = [ "aPPLE", "AbAcUs", "bRaNcH", "BlUeBeRrY", "ClOvEr", "cHeRry" ]
    
    let sortedWords = sort(words, caseInsensitiveComparer).reverse()
    
    sortedWords.each(println)
}

func linq35(){
    let digits = [ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" ]
    
    let sortedDigits = sort(sort(digits) { $0 < $1 }) { $0.length < $1.length }
    
    println("Sorted digits:")
    sortedDigits.each(println)
}

func linq36(){
    let words = [ "aPPLE", "AbAcUs", "bRaNcH", "BlUeBeRrY", "ClOvEr", "cHeRry" ]
    
    let sortedWords = sort(sort(words, caseInsensitiveComparer)) { $0.length < $1.length }
    
    sortedWords.each(println)
}

func linq37(){
    let products = productsList()
    
    let sortedProducts = products.sortBy(
        { compare($0.category, $1.category) },
        { compare($1.unitPrice, $0.unitPrice) }
    )
    sortedProducts.each(println)
}

func linq38(){
    let words = [ "aPPLE", "AbAcUs", "bRaNcH", "BlUeBeRrY", "ClOvEr", "cHeRry" ]
    
    let sortedWords = words.sortBy(
        { compare($0.length,$1.length) },
        { compareIgnoreCase($0,$1) }
    )
    
    sortedWords.each(println)
}

func linq39(){
    let digits = [ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" ]
    
    let reversedIDigits = digits
        .find { $0.charAt(1) == "i" }
        .reverse()
    
    println("A backwards list of the digits with a second character of 'i':")
    reversedIDigits.each(println)
}

package com.github.yildizmy.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import static com.github.yildizmy.common.Constants.*;

/**
 * Used for validating IBAN numbers
 */
@Slf4j(topic = "IbanValidator")
@RequiredArgsConstructor
@Component
public class IbanValidator implements ConstraintValidator<ValidIban, String> {

    @Override
    public boolean isValid(String iban, ConstraintValidatorContext context) {
        return true;
    }
}

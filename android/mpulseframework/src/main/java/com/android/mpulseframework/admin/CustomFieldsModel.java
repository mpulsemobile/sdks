package com.android.mpulseframework.admin;

/**
 * Other fields for member or Events
 * Fields can add at run time
 */

public class CustomFieldsModel {
        /**
         * Keys for Field
         * */
        private String key;

        /**
         * Values for Field
         * */
        private String value;

        /**
         *
         * @return
         */
        public String getKey() {
            return key;
        }

        /**
         *
         * @param key
         */
        public void setKey(String key) {
            this.key = key;
        }

        /**
         *
         * @return
         */
        public String getValue() {
            return value;
        }

        /**
         *
         * @param value
         */
        public void setValue(String value) {
            this.value = value;
        }
    }


